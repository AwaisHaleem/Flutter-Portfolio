import 'package:flutter/material.dart';
import 'package:twitch_clone/Recources/auth_methods.dart';
import 'package:twitch_clone/Responsive/responsive.dart';
import 'package:twitch_clone/Screens/home_screen.dart';
import 'package:twitch_clone/Widgets/custom_button.dart';
import 'package:twitch_clone/Widgets/custom_textfield.dart';
import 'package:twitch_clone/Widgets/loading_indicator.dart';

class LogIn extends StatefulWidget {
  static const String routName = "/LogIn";
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  logInUser() async {
    setState(() {
      _isLoading = true;
    });
    final res = await _authMethods.logInUser(
        _emailController.text, _passwordController.text, context);
    setState(() {
      _isLoading = false;
    });
    if (res) Navigator.pushReplacementNamed(context, HomeScreen.routName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogIn"),
      ),
      body: _isLoading? const LoadingIndicator() : 
      Responsive(
        child: SingleChildScrollView(
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
                CustomButton(title: "LogIn", onTap: logInUser)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
