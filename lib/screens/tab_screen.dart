import 'package:flutter/material.dart';

import '../src/constants.dart';
import 'message_screen.dart';
import 'profile_screen.dart';
import 'video_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _screenIndex = 0;

  List screens = [
    const VideoScreen(),
    const Center(
      child: Text('haha1'),
    ),
    const Center(
      child: Text('haha12'),
    ),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenIndex == 0 ? CustomColors.black : null,
      body: screens[_screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 26,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: CustomAddIcon(
              iconData: Icons.add,
              primaryColor:
                  _screenIndex == 0 ? CustomColors.white : CustomColors.black,
              accentColor:
                  _screenIndex == 0 ? CustomColors.black : CustomColors.white,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
        currentIndex: _screenIndex,
        onTap: (newIndex) {
          setState(() {
            _screenIndex = newIndex;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            _screenIndex == 0 ? CustomColors.black : CustomColors.white,
        selectedItemColor:
            _screenIndex == 0 ? CustomColors.white : CustomColors.black,
        unselectedItemColor: CustomColors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
}

class CustomAddIcon extends StatelessWidget {
  const CustomAddIcon({
    Key? key,
    required this.iconData,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  final IconData iconData;

  final Color primaryColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      width: 44,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            width: 34,
            decoration: BoxDecoration(
              color: CustomColors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 34,
            decoration: BoxDecoration(
              color: CustomColors.pink,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                iconData,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
