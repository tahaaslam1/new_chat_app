import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/blocs/news/news_bloc.dart';
import 'package:new_chat_app/services/http_service.dart';
import 'package:new_chat_app/services/snack_bar_service.dart';

class Injector extends StatelessWidget {
  final Widget child;

  const Injector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _GlobalServiceInjector(
      //  child: _GlobalRepositoryInjector(
      child: _GlobalBlocInjector(
        child: child,
      ),
      // ),
    );
  }
}

// class _GlobalRepositoryInjector extends StatelessWidget {
//   final Widget child;

//   const _GlobalRepositoryInjector({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider<AuthenticationRepository>(
//             create: (context) => FirebaseAuthRepository(
//                   localStorageService: context.read<LocalStorageService>(),
//                 )),
//         RepositoryProvider<PokemonRepository>(create: (context) => PokemonRepositoryImpl(httpService: context.read<HttpService>(), localStorageService: context.read<LocalStorageService>())),
//       ],
//       child: child,
//     );
//   }
// }

class _GlobalBlocInjector extends StatelessWidget {
  final Widget child;

  const _GlobalBlocInjector({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(create: (context) => NewsBloc(httpService: context.read<HttpService>())),
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
        //   RepositoryProvider(create: (context) => LocalStorageService()),
      ],
      child: child,
    );
  }
}
