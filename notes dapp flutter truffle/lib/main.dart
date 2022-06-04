import 'package:flutter/material.dart';
import 'package:notes_dapp/Providers/notes.dart';
import 'package:notes_dapp/home.dart';
import 'package:provider/provider.dart';

import 'Providers/home1.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => NotesServices(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes dApp',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
