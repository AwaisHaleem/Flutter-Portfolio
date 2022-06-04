import 'package:flutter/material.dart';
import 'package:twitch_clone/Screens/feed_screen.dart';
import 'package:twitch_clone/Screens/go_live_screen.dart';
import 'package:twitch_clone/Utils/colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  final List<Widget> _pages = const [
    FeedScreen(),
    GoLive(),
    Center(
      child: Text("Brows"),
    )
  ];

  pageSelector(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: pageSelector,
          currentIndex: _page,
          selectedItemColor: buttonColor,
          unselectedItemColor: primaryColor,
          backgroundColor: backgroundColor,
          selectedFontSize: 14,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Following"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_rounded), label: "Go Live"),
            BottomNavigationBarItem(icon: Icon(Icons.copy), label: "Browse"),
          ]),
      body: _pages[_page],
    );
  }
}
