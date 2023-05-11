import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/cubits/auth/authentication_cubit.dart';
import 'package:new_chat_app/app/models/user.dart';
import 'package:new_chat_app/app/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:new_chat_app/app/presentation/widgets/buttons/custom_outlined_button.dart';
import 'package:new_chat_app/core/app_navigator/app_navigator.dart';
import 'package:new_chat_app/services/extension_methods.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Hi ${User.instance.username!.toTitleCase()}'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    AppNavigator.push(Routes.chat);
                  },
                  buttonText: 'Join the chat room',
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20.0),
                CustomElevatedButton(
                  onPressed: () {
                    AppNavigator.push(Routes.news);
                  },
                  buttonText: 'View top headlines in United States',
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20.0),
                CustomOutlinedButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationCubit>(context).logout();
                  },
                  buttonText: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
