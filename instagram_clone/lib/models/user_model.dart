import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String photoUrl;
  final List follower;
  final List following;

  UserModel(
      {required this.username,
      required this.email,
      required this.uid,
      required this.bio,
      required this.photoUrl,
      required this.follower,
      required this.following});

  Map<String, dynamic> toJson() => {
        "id": uid,
        "username": username,
        "email": email,
        "bio": bio,
        "followers": [],
        "following": [],
        "profileImage": photoUrl
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapShot["username"],
      email: snapShot["email"],
      uid: snapShot["id"],
      bio: snapShot["bio"],
      photoUrl: snapShot["profileImage"],
      follower: snapShot["followers"],
      following: snapShot["following"],
    );
     
  }
}
