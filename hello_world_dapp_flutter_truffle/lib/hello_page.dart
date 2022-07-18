import 'package:flutter/material.dart';
import 'package:hello_world_dapp_flutter_truffle/contract_linking.dart';
import 'package:provider/provider.dart';

class HelloPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
   HelloPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter dApp"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              Text("Welcome dApp ${contractLink.deployedName}"),
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(hintText: "Enter Message"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    contractLink.setMessage(_controller.text);
                    _controller.clear();
                  },
                  child: const Text("Set Message"))
            ],
          )),
        )),
      ),
    );
  }
}
