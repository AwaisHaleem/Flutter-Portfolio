import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/Models/live_streem.dart';
import 'package:twitch_clone/Provider/user_provider.dart';
import 'package:twitch_clone/Recources/storage_methods.dart';
import 'package:twitch_clone/Utils/utils.dart';

class FireStoreMethods {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStreem(
      BuildContext context, String title, Uint8List? img) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String channelId = '';
    try {
      if (title.isNotEmpty && img != null) {
        if (!(await _fireStore
                .collection("LiveStream")
                .doc("${user.user.uid}${user.user.username}")
                .get())
            .exists) {
          final String thumbNailUrl =
              await _storageMethods.upLoadImageToStorage(
                  "Live Stream Thumbnail", img, user.user.uid);

          channelId = "${user.user.uid}${user.user.username}";

          final LiveStreem liveStreem = LiveStreem(
              title: title,
              image: thumbNailUrl,
              uid: user.user.uid,
              username: user.user.username,
              startedAt: DateTime.now(),
              viewers: 0,
              channelId: channelId);

          _fireStore.collection("LiveStream").doc(channelId).set(
                liveStreem.toMap(),
              );
        } else {
          showSnackBar(
              context, "Two LiveStreams can not start at the same time");
        }
      } else {
        showSnackBar(context, "Please enter all the Fields");
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
    return channelId;
  }
}
