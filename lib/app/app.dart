import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:new_chat_app/app/cubits/auth/authentication_cubit.dart';
import 'package:new_chat_app/app/presentation/screens/home/home_screen.dart';
import 'package:new_chat_app/app/presentation/screens/login/login_screen.dart';
import 'package:new_chat_app/app/presentation/screens/news/news_screen.dart';
import 'package:new_chat_app/app/presentation/screens/register/register_screen.dart';
import 'package:new_chat_app/app/presentation/screens/splash/splash_screen.dart';
import 'package:new_chat_app/services/injector.dart';

import '../core/app_navigator/app_navigator.dart';
import '../core/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Injector(
      child: FlutterWebFrame(
          maximumSize: const Size.fromWidth(600),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          enabled: kIsWeb || !Platform.isAndroid && !Platform.isIOS,
          builder: (context) {
            return MaterialApp(
              title: 'News Chat App',
              debugShowCheckedModeBanner: false,
              navigatorKey: AppNavigator.navigatorKey,
              theme: AppTheme.theme,
              onGenerateRoute: AppNavigator.onGenerateRoute,
              builder: (context, child) {
                return BlocListener<AuthenticationCubit, AuthenticationState>(
                  listener: (context, state) => AppNavigator.navigate(state.status),
                  child: child,
                );
              },
            );
          }),
    );
  }
}
