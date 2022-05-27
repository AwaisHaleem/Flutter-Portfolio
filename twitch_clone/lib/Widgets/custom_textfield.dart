import 'package:flutter/material.dart';
import 'package:twitch_clone/Utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: buttonColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryBackgroundColor),
        ),
      ),
    );
  }
}
