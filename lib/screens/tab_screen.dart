import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/screens/add_video_screen.dart';

import '../src/constants.dart';
import 'profile_screen.dart';
import 'videos_screen.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({
    Key? key,
    this.screenIndex = 0,
  }) : super(key: key);

  final int screenIndex;

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  late int _screenIndex;

  @override
  initState() {
    super.initState();
    _screenIndex = widget.screenIndex;
  }

  List screens = [
    const VideosScreen(),
    const Center(
      child: Text('haha1'),
    ),
    const AddVideoScreen(),
    // const MessageScreen(),
    const Center(
      child: Text('haha1'),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenIndex == 0 ? CustomColors.black : null,
      // appBar: AppBar(
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: _screenIndex == 0 ? Colors.transparent : Colors.black,
      //   ),
      // ),
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
