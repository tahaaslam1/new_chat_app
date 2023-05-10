import 'package:flutter/material.dart';
import 'package:new_chat_app/app/presentation/widgets/buttons/custom_elevated_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Hi UserNames'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomElevatedButton(
                  onPressed: () {},
                  buttonText: 'Join the chat room',
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20.0),
                CustomElevatedButton(
                  onPressed: () {},
                  buttonText: 'View top headlines in United States',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
