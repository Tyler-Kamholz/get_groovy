import 'package:flutter/material.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:getgroovy/pages/notifications_page.dart';
import 'package:getgroovy/pages/post_page.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/pages/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex = 1;

  List pages = [
    const NotificationsPage(),
    const HomePage(),
    const PostPage(),
    const SearchPage(),
    const ProfilePage(),
  ];

  void onTap(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white.withOpacity(0),
        iconSize: 30,
        unselectedFontSize: 0, //only icons can be pressed
        selectedFontSize: 0, //this makes the icons the only ones being pressed
        onTap: onTap, //this changes the index
        currentIndex: pageIndex, //this moves the icons to show being pressed
        selectedItemColor: Colors.black, //icons are black
        unselectedItemColor:
            Colors.grey.withOpacity(.5), //icons not pressed are grey
        showSelectedLabels: false, //no labels
        showUnselectedLabels: false, //no labels
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ], //these are all the pages above this comment.
      ),
    );
  }
}
