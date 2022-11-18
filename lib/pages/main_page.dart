import 'package:flutter/material.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:getgroovy/pages/notifications_page.dart';
import 'package:getgroovy/pages/post_page.dart';
import 'package:getgroovy/pages/profile_page.dart';
import 'package:getgroovy/pages/search_page.dart';
import 'package:getgroovy/pages/settings_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../spotify/spotify_provider.dart';

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
    Consumer<SpotifyProvider>(builder: (context, value, child) {
      return PostPage(provider: value,);
    },),
    const SearchPage(),
    const ProfilePage(
      userID: 'Rob Bobertson',
      showFollowButton: false,
    ),
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
          title: const Text("Get Groovy"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  notifications(context);
                },
                icon: const Icon(Icons.notifications),
                tooltip: 'Notifications',
                iconSize: 26,
              ),
            ),
          ],
          controller: controller,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () {
                settings(context);
              },
              icon: const Icon(Icons.menu),
              tooltip: 'Settings',
            ),
          ),
        ),
        body: pages[pageIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: GNav(
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(
                icon: Icons.add_circle_outline,
                text: 'Post',
              ),
              GButton(
                icon: Icons.search_outlined,
                text: 'Search',
              ),
              GButton(
                icon: Icons.person_outline,
                text: 'Profile',
              ),
            ],
            gap: 10,
            padding: const EdgeInsets.all(20),
            onTabChange: onTap,
          ),
        ));
  }

  void settings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: false, builder: (context) => const SettingsPage()));
  }

  void notifications(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => const NotificationsPage()));
  }
}
