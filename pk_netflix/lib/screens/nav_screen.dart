import 'package:flutter/material.dart';
import 'package:pk_netflix/screens/home_screen.dart';
import 'package:pk_netflix/widgets/responsive.dart';

class NavScreen extends StatefulWidget {
  NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> screens = [
    const HomeScreen(
      key: PageStorageKey("homeScreen"),
    ),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold()
  ];

  final Map<String, IconData> _icons = const {
    'Home': Icons.home,
    'Search': Icons.search,
    'Coming Soon': Icons.queue_play_next,
    'Downloads': Icons.file_download,
    'Moew': Icons.menu
  };

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: !Responsive.isDesktop(context)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              items: _icons
                  .map(
                    (title, icon) => MapEntry(
                      title,
                      BottomNavigationBarItem(
                        icon: Icon(
                          icon,
                          size: 30.0,
                        ),
                        label: title,
                      ),
                    ),
                  )
                  .values
                  .toList(),
              currentIndex: _currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 11.0,
              unselectedFontSize: 11.0,
              onTap: (index) => setState(() => {_currentIndex = index}),
            )
          : null,
    );
  }
}
