import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FirestoreMethods().uploadPost(
          uid, _descriptionController.text, _file!, username, profImage);

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "Posted");
        _clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void _clearImage() {
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text("Take a Photo"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text("Choose from gallery"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    _clearImage();
                    _descriptionController.text = "";
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                      userProvider.getUser!.uid,
                      userProvider.getUser!.username,
                      userProvider.getUser!.photoUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            body: Column(children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(userProvider.getUser!.photoUrl),
                  ),
                  SizedBox(
                    width: size.width * 0.45,
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Write a caption",
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(_file!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider()
            ]),
          );
  }
}
