import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/Recources/auth_methods.dart';
import 'package:twitch_clone/Screens/home_screen.dart';
import 'package:twitch_clone/Screens/onboarding_screen.dart';

import '../Models/user.dart';
import '../Provider/user_provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? _user;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      updateUserState(event);
    });

    super.initState();
  }

  updateUserState(event) async {
    setState(() {
      _user = event;
    });
    if (event != null)  {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userValue = await AuthMethods().getCurrentUser(uid);
      await Provider.of<UserProvider>(context, listen: false).setUser(
        UserModel.fromMap(userValue),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const OnboardingScreen();
    } else {
      return const HomeScreen();
    }
  }
}
