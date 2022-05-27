import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/Provider/user_provider.dart';
import 'package:twitch_clone/Recources/auth_methods.dart';
import 'package:twitch_clone/Screens/home_screen.dart';
import 'package:twitch_clone/Screens/login_screen.dart';
import 'package:twitch_clone/Screens/signup_screen.dart';
import 'package:twitch_clone/Utils/colors.dart';
import 'package:twitch_clone/Widgets/loading_indicator.dart';
import 'package:twitch_clone/Widgets/wrapper.dart';

import 'Screens/onboarding_screen.dart';
import 'firebase_options.dart';
import 'Models/user.dart' as model;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Twitch Clone",
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme.of(context).copyWith(
            foregroundColor: primaryColor,
            centerTitle: true,
            color: backgroundColor,
            elevation: 0,
            titleTextStyle: const TextStyle(
                color: primaryColor, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          iconTheme: const IconThemeData(color: primaryColor),
        ),
        routes: {
          OnboardingScreen.routName: (context) => const OnboardingScreen(),
          LogIn.routName: (context) => const LogIn(),
          SignUp.routName: (context) => const SignUp(),
          HomeScreen.routName: (context) => const HomeScreen(),
        },
        home: const Wrapper()
        // FutureBuilder(
        //   future: AuthMethods()
        //       .getCurrentUser(FirebaseAuth.instance.currentUser != null
                  // ? FirebaseAuth.instance.currentUser!.uid
        //           : null)
        //       .then((value) {
        //     if (value != null) {
        //       Provider.of<UserProvider>(context).setUser(
        //         model.User.fromMap(value),
        //       );
        //     }
        //     return value;
        //   }),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const LoadingIndicator();
        //     }

        //     if (snapshot.hasData) {
        //       return const HomeScreen();
        //     }
        //     return const OnboardingScreen();
        //   },
        // ),
      ),
    );
  }
}
