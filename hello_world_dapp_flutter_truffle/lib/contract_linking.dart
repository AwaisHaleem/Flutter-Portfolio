import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = Platform.isAndroid? "http://10.0.2.2:7545": "http://127.0.0.1:7545";
  final String _wsUrl = Platform.isAndroid? "ws://10.0.2.2:7545":"ws://127.0.0.1:7545";
  static const String _privateKey =
      "eb6f4da0212751cb4eddb5f98206e1e35373142fa05c10726b833fa747a638a9";

  Web3Client? _web3client;
  bool isLoading = true;

  String? _abiCode;
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;
  ContractFunction? _message;
  ContractFunction? _setMessage;

  String? deployedName;

  ContractLinking() {
    setUp();
  }

  setUp() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    final String abiStringFile =
        await rootBundle.loadString("build/contracts/HelloWorld.json");

    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "HelloWorld"), _contractAddress!);

    _setMessage = _contract!.function("setMessage");
    _message = _contract!.function("message");
    getMessage();
  }

  getMessage() async {
    final myMessage = await _web3client!
        .call(contract: _contract!, function: _message!, params: []);
    deployedName = myMessage[0];
    isLoading = false;
    notifyListeners();
  }

  setMessage(String message) async {
    isLoading = true;
    notifyListeners();
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setMessage!,
            parameters: [message]));
    getMessage();
  }
}
