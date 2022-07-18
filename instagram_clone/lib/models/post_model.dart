import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String postId;
  final String description;
  final String profImageUrl;
  final datePublished;
  final String postUrl;
  final  likes;

  const Post(
      {required this.uid,
      required this.username,
      required this.postId,
      required this.description,
      required this.profImageUrl,
      required this.datePublished,
      required this.postUrl,
      required this.likes});

  Map<String, dynamic> toJson() {
    return {
      "id": uid,
      "username": username,
      "postId": postId,
      "description": description,
      "profImageUrl": profImageUrl,
      "datePublished": datePublished,
      "postUrl": postUrl,
      "likes": likes
    };
  }

  static Post fromSnapShot(DocumentSnapshot snap) {
    return Post(
        uid: snap["id"],
        username: snap["username"],
        postId: snap["postId"],
        description: snap["description"],
        profImageUrl: snap["profileImageUrl"],
        datePublished: snap["datePublished"],
        postUrl: snap["postUrl"],
        likes: snap["likes"]);
  }
}
