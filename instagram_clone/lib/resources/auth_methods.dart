import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storage = StorageMethods();

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List image}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          image != null) {
        final UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final String imageUrl =
            await _storage.uploadImageToStorage("profileImage", image, false);

        UserModel userModel = UserModel(
            username: username,
            email: email,
            uid: cred.user!.uid,
            bio: bio,
            photoUrl: imageUrl,
            follower: [],
            following: []);

        if (cred.user != null) {
          _firestore
              .collection("users")
              .doc(cred.user!.uid)
              .set(userModel.toJson());
          res = "success";
        }
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userSignIn = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
        DocumentSnapshot snap = await _firestore
            .collection("users")
            .doc(userSignIn.user!.uid)
            .get();
      } else {
        res = "please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }

  Future<UserModel> getUserDetail() async {
    var currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snapshot);
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
