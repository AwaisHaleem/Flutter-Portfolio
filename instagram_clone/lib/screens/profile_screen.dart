import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/follow_button.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/sign_in_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followersLen = 0;
  int followingLen = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      followersLen = userSnap.data()!["followers"].length;
      followingLen = userSnap.data()!["following"].length;
      isFollowing = userSnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData["username"]),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              NetworkImage(userData["profileImage"]),
                          radius: 40,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildCoulumn(postLen, "posts"),
                                  buildCoulumn(followersLen, "followers"),
                                  buildCoulumn(followingLen, "following")
                                ],
                              ),
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? FollowButton(
                                      backgroundColor: mobileBackgroundColor,
                                      borderColor: Colors.grey,
                                      text: "Sign Out",
                                      textColor: primaryColor,
                                      function: () async {
                                        await AuthMethods().signout();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInScreen()));
                                      },
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          backgroundColor: Colors.white,
                                          borderColor: Colors.grey,
                                          text: "Unfollow",
                                          textColor: Colors.black,
                                          function: () {
                                            FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData["id"]);
                                            setState(() {
                                              isFollowing = false;
                                              followersLen--;
                                            });
                                          })
                                      : FollowButton(
                                          backgroundColor: Colors.blue,
                                          borderColor: Colors.blue,
                                          text: "Follow",
                                          textColor: primaryColor,
                                          function: () {
                                            FirestoreMethods().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                userData["id"]);
                                            setState(() {
                                              isFollowing = true;
                                              followersLen++;
                                            });
                                          })
                            ],
                          ),
                        )
                      ]),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData["bio"],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("id", isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapShot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 3,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapShot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    })
              ],
            ),
          );
  }

  Column buildCoulumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
