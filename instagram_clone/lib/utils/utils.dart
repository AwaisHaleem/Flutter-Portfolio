import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  XFile? file = await ImagePicker().pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackBar(BuildContext context, String content) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content)));
}
