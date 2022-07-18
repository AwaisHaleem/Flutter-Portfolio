import 'package:flutter/material.dart';
import 'package:hello_world_dapp_flutter_truffle/contract_linking.dart';
import 'package:provider/provider.dart';

import 'hello_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
      create: (context) => ContractLinking(),
      child: MaterialApp(
        title: 'Hello Word dApp',
        theme: ThemeData(
          
          primarySwatch: Colors.blue,
        ),
        home:  HelloPage()
      ),
    );
  }
}

