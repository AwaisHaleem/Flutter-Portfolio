import 'package:flutter/material.dart';
import 'package:twitch_clone/Screens/home_screen.dart';
import 'package:twitch_clone/Widgets/custom_button.dart';
import 'package:twitch_clone/Widgets/custom_textfield.dart';
import 'package:twitch_clone/Widgets/loading_indicator.dart';

import '../Recources/auth_methods.dart';

class SignUp extends StatefulWidget {
  static const String routName = "/signup";
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    final bool res = await _authMethods.signUpUser(_emailController.text,
        _userNameController.text, _passwordController.text, context);
    setState(() {
      _isLoading = false;
    });
    if (res) Navigator.pushReplacementNamed(context, HomeScreen.routName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp"),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    const Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(controller: _emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Username",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(controller: _userNameController),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(controller: _passwordController),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(title: "SignUp", onTap: signUp)
                  ],
                ),
              ),
            ),
    );
  }
}
