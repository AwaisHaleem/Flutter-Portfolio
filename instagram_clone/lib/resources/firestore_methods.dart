import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String uid, String description, Uint8List file,
      String username, String profileImageUrl) async {
    String res = "Some error occured";
    try {
      String imageUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          username: username,
          postId: postId,
          description: description,
          profImageUrl: profileImageUrl,
          datePublished: DateTime.now(),
          postUrl: imageUrl,
          likes: []);

      await _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } on FirebaseException catch (e) {
      res = e.message!;
    }
    return res;
  }

  Future<void> likeUpdate(String postId, List likes, String uid) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String uid, String text, String name,
      String profPic) async {
    try {
      if (text.isNotEmpty) {
        final String commentId = Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profImageUrl": profPic,
          "text": text,
          "uid": uid,
          "userName": name,
          "postId": postId,
          "commentId": commentId,
          "commentDate": DateTime.now()
        });
      } else {
        print("text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List followers = (snap.data()! as dynamic)["followers"];

      if (followers.contains(followId)) {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid])
        });

        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
