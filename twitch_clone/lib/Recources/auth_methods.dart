import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/Models/user.dart';
import 'package:twitch_clone/Provider/user_provider.dart';
import 'package:twitch_clone/Utils/utils.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
    return null;
  }

  Future<bool> signUpUser(
    String email,
    String username,
    String password,
    BuildContext context,
  ) async {
    bool res = false;
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel user = UserModel(
          uid: cred.user!.uid, username: username.trim(), email: email.trim());

      await _userRef.doc(cred.user!.uid).set(user.toMap());
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      res = true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> logInUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    bool res = false;
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);


      Provider.of<UserProvider>(context, listen: false).setUser(
        UserModel.fromMap(await getCurrentUser(cred.user!.uid) ?? {}),
      );

      res = true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    return res;
  }
}
