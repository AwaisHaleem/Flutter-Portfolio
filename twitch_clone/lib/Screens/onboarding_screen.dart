import 'package:flutter/material.dart';
import 'package:twitch_clone/Screens/login_screen.dart';
import 'package:twitch_clone/Screens/signup_screen.dart';
import 'package:twitch_clone/Widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routName = "/onboarding";
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome to \nTwitch",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomButton(
                title: "Login",
                onTap: () {
                  Navigator.pushNamed(context, LogIn.routName);
                }),
          ),
          CustomButton(
              title: "Sign Up",
              onTap: () {
                Navigator.pushNamed(context, SignUp.routName);
              })
        ],
      ),
    ));
  }
}
