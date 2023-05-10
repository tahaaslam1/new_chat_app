import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:new_chat_app/app/presentation/widgets/auth_screen_wrapper.dart';
import 'package:new_chat_app/app/presentation/widgets/buttons/custom_elevated_button.dart';
import 'package:new_chat_app/app/presentation/widgets/buttons/custom_outlined_button.dart';
import 'package:new_chat_app/app/presentation/widgets/divider_with_text.dart';
import 'package:new_chat_app/core/app_navigator/app_navigator.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      isAuthenticating: false,
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            const SizedBox(height: 24),
            FormBuilderTextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              name: 'password',
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(8),
              ]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    String email = _formKey.currentState!.value['email'];
                    String password = _formKey.currentState!.value['password'];
                    // context.read<LoginCubit>().login(email, password);
                  }
                },
                buttonText: 'Login',
              ),
            ),
            const SizedBox(height: 20),
            const DividerWithText(text: 'OR'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomOutlinedButton(
                onPressed: () => AppNavigator.replaceWith(Routes.register),
                buttonText: 'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
