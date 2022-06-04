import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<Uint8List?> pickImag() async {
  FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (pickedImage != null) {
    if (kIsWeb) {
      return await pickedImage.files.single.bytes;
    }
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}