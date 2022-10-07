import 'package:flutter/material.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:getgroovy/pages/post_page.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/pages/search_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = ScrollController();

  int pageIndex = 0;
  List pages = [
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
        appBar: ScrollAppBar(
          controller: controller,
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
            color: Colors.white,
          ),
        ),
        body: pages[pageIndex],
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: GNav(
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.add_circle,
                  text: 'Post',
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              gap: 10,
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.all(20),
              onTabChange: onTap,
            ),
          ),
        ));
  }
}
