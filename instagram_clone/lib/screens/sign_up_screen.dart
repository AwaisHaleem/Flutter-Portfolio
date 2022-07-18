import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_view_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/responsive/web_view_layout.dart';
import 'package:instagram_clone/screens/sign_in_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    _emaiController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emaiController.text,
        password: _passwordController.text,
        username: _userNameController.text,
        bio: _bioController.text,
        image: _image!);
    if (res == "success") {
      
      Navigator.pushReplacement( context,
      MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileViewLayout: MobileViewLayout(),
              webViewLayout: WebViewLayout())));
    } else {
      showSnackBar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }

  void pickedImgae() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
          size.width > webWidth? EdgeInsets.symmetric(horizontal: size.width/3):
           const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.08,
                ),
                SvgPicture.asset("assets/logo.svg",
                    color: primaryColor, height: 64),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG.png"),
                          ),
                    Positioned(
                      bottom: -10,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: pickedImgae,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                    controller: _userNameController,
                    hitText: "Enter Your Username",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                    controller: _emaiController,
                    hitText: "Enter Your Email",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hitText: "Enter Your Password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomTextField(
                    controller: _bioController,
                    hitText: "Enter Your Bio",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: blueColor),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 1,
                            ),
                          )
                        : const Text("Sign UP"),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("have an account?"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "SignIn",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
