import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:twitch_clone/Recources/firestore_methods.dart';
import 'package:twitch_clone/Screens/broadcast_screen.dart';
import 'package:twitch_clone/Utils/colors.dart';
import 'package:twitch_clone/Widgets/custom_button.dart';
import 'package:twitch_clone/Widgets/custom_textfield.dart';

import '../Utils/utils.dart';

class GoLive extends StatefulWidget {
  const GoLive({Key? key}) : super(key: key);

  @override
  State<GoLive> createState() => _GoLiveState();
}

class _GoLiveState extends State<GoLive> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    final String channelId = await FireStoreMethods()
        .startLiveStreem(context, _titleController.text, _image!);

    showSnackBar(context, "Live Stream has been Started");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>  BroadcastScreen(isBroadcaster: true, channelId: channelId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Uint8List? pickeImage = await pickImag();
                      setState(() {
                        _image = pickeImage;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 20),
                      child: _image != null
                          ? SizedBox(
                              height: 300,
                              child: Image.memory(_image!),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              color: buttonColor,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: buttonColor.withOpacity(0.05),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                      color: buttonColor,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select Your Thumbnail",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CustomTextField(controller: _titleController),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomButton(
                  title: "Go Live",
                  onTap: goLiveStream,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
