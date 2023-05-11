import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/blocs/news/news_bloc.dart';
import 'package:new_chat_app/app/cubits/auth/authentication_cubit.dart';
import 'package:new_chat_app/app/cubits/register/register_cubit.dart';
import 'package:new_chat_app/app/repositories/auth_repository/auth_repository.dart';
import 'package:new_chat_app/app/repositories/auth_repository/auth_repository_impl.dart';
import 'package:new_chat_app/app/repositories/message_repository/message_repository.dart';
import 'package:new_chat_app/app/repositories/message_repository/message_repository_impl.dart';
import 'package:new_chat_app/app/repositories/news_repository/news_repository.dart';
import 'package:new_chat_app/app/repositories/news_repository/news_repository_impl.dart';
import 'package:new_chat_app/services/firebase_service.dart';
import 'package:new_chat_app/services/http_service.dart';
import 'package:new_chat_app/services/snack_bar_service.dart';

class Injector extends StatelessWidget {
  final Widget child;

  const Injector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _GlobalServiceInjector(
      child: _GlobalRepositoryInjector(
        child: _GlobalBlocInjector(
          child: child,
        ),
      ),
    );
  }
}

class _GlobalRepositoryInjector extends StatelessWidget {
  final Widget child;

  const _GlobalRepositoryInjector({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NewsRepository>(create: (context) => NewsRepositoryImpl(httpService: context.read<HttpService>())),
        RepositoryProvider<AuthenticationRepository>(create: (context) => AuthenticationRepositoryImpl()),
        RepositoryProvider<MessageRepository>(create: (context) => MessageRepositoryImpl(firebaseService: context.read<FirebaseService>())),
      ],
      child: child,
    );
  }
}

class _GlobalBlocInjector extends StatelessWidget {
  final Widget child;

  const _GlobalBlocInjector({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(create: (context) => NewsBloc(newsRepository: context.read<NewsRepository>())),
        BlocProvider<AuthenticationCubit>(create: (context) => AuthenticationCubit(authenticationRepository: context.read<AuthenticationRepository>())),
      ],
      child: child,
    );
  }
}

class _GlobalServiceInjector extends StatelessWidget {
  final Widget child;

  const _GlobalServiceInjector({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HttpService>(create: (context) => HttpService()),
        RepositoryProvider<SnackBarService>(create: (context) => SnackBarService()),
        RepositoryProvider<FirebaseService>(create: (context) => FirebaseService(firestore: FirebaseFirestore.instance)),
      ],
      child: child,
    );
  }
}
