import 'package:firebase_auth/firebase_auth.dart';
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
import '../themes/theme_provider.dart';

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
    Consumer<SpotifyProvider>(
      builder: (context, value, child) {
        return PostPage(
          provider: value,
        );
      },
    ),
    const SearchPage(),
    ProfilePage(
      userID: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  void onTap(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ScrollAppBar(
        toolbarHeight: size.height * .05,
        backgroundColor:
            Provider.of<ThemeProvider>(context).getCurrentTheme().navBarColor,
        title: Image.asset(
          Provider.of<ThemeProvider>(context).getCurrentTheme().homeLogo,
          width: size.height * .25,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                settings(context);
              },
              icon: Icon(
                Icons.menu,
                color: Provider.of<ThemeProvider>(context)
                    .getCurrentTheme()
                    .iconColor,
              ),
              tooltip: 'Settings',
            ),
          ),
        ],
        controller: controller,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              notifications(context);
            },
            icon: Icon(
              Icons.notifications,
              color: Provider.of<ThemeProvider>(context)
                  .getCurrentTheme()
                  .iconColor,
            ),
            tooltip: 'Notifications',
            iconSize: 26,
          ),
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: GNav(
        activeColor: Provider.of<ThemeProvider>(context)
            .getCurrentTheme()
            .textBoxTextColor,
        color: Provider.of<ThemeProvider>(context).getCurrentTheme().iconColor,
        backgroundColor:
            Provider.of<ThemeProvider>(context).getCurrentTheme().navBarColor,
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
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
        onTabChange: onTap,
      ),
    );
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
