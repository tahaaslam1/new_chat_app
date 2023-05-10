import 'package:flutter/material.dart';

class AuthScreenWrapper extends StatelessWidget {
  final Widget child;
  final bool isAuthenticating;
  const AuthScreenWrapper({super.key, required this.child, required this.isAuthenticating});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAuthenticating,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
