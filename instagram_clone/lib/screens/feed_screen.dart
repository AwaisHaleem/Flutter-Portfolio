import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/postcard.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > webWidth
          ? null
          : AppBar(
              backgroundColor:
                  width > webWidth ? webBackgroundColor : mobileBackgroundColor,
              title: SvgPicture.asset(
                "assets/logo.svg",
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.messenger_outline))
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapShot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width > webWidth ? width * 0.3 : 0,
                        vertical: width > webWidth ? 15 : 0),
                    child: PostCard(snap: snapShot.data!.docs[index]),
                  ));
        },
      ),
    );
  }
}
