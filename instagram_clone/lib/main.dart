import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_view_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/responsive/web_view_layout.dart';
import 'package:instagram_clone/screens/sign_in_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<UserProvider>(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        title: "Instagram Clone",
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.active) {
              if (snapShot.hasData) {
                return const ResponsiveLayout(
                  mobileViewLayout: MobileViewLayout(),
                  webViewLayout: WebViewLayout(),
                );
              } else if (snapShot.hasError) {
                return Scaffold(
                  body: Center(child: Text("${snapShot.error}")),
                );
              }
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                )),
              );
            }
            return const SignInScreen();
          },
        ),
      ),
    );
  }
}
