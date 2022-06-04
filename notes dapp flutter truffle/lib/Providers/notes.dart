import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:notes_dapp/Models/note.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class NotesServices with ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = true;

  final String _rpcUrl = Platform.isAndroid? "http://10.0.0.1:7545" : "http://127.0.0.1:7545";
  final String _wsUrl = Platform.isAndroid? "ws://10.0.0.1:7545": "ws://127.0.0.1:7545";

  final String _privateKey =
      "2850ecaf0b8071f8be726513733b90a4016d9d1a53090eafb6c59c2e2207db34";

  NotesServices() {
    init();
  }

  Web3Client? _web3Client;

  Future<void> init() async {
    _web3Client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getABI();
    await getCredentials();
    await getDeployedContracr();
  }

  ContractAbi? _abiCode;
  EthereumAddress? _contractAddress;

  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString("build/contracts/NotesContract.json");
    var jsonABI = jsonDecode(abiFile);

    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NotesContrac');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI['networks']['5777']['address']);
  }

  EthPrivateKey? _cred;

  Future<void> getCredentials() async {
    _cred = EthPrivateKey.fromHex(_privateKey);
  }

  DeployedContract? _deployedContract;
  ContractFunction? _createNote;
  ContractFunction? _deleteNote;
  ContractFunction? _notes;
  ContractFunction? _notesCount;

  Future<void> getDeployedContracr() async {
    _deployedContract = DeployedContract(_abiCode!, _contractAddress!);
    _createNote = _deployedContract!.function("createNote");
    _deleteNote = _deployedContract!.function("deleteNote");
    _notes = _deployedContract!.function("notes");
    _notesCount = _deployedContract!.function("noteCount");

    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _web3Client!
        .call(contract: _deployedContract!, function: _notesCount!, params: []);

    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();

    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3Client!.call(
          contract: _deployedContract!,
          function: _notesCount!,
          params: [BigInt.from(i)]);

      if (temp[1] != "") {
        notes.add(Note(
            id: (temp[0] as BigInt).toInt(),
            title: temp[1],
            description: temp[2]));
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String description) async {
    await _web3Client!.sendTransaction(
        _cred!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: _createNote!,
            parameters: [title, description]));
    isLoading = true;
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await _web3Client!.sendTransaction(
        _cred!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: _deleteNote!,
            parameters: [BigInt.from(id)]));
    isLoading = true;
    notifyListeners();
    fetchNotes();
  }
}
