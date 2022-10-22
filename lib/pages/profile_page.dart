import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/helpers/helpers.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/post_card_builder.dart';

/// Widget to display user profiles
class ProfilePage extends StatefulWidget {
  /// user ID which will eventually be used to pull relavent other data
  // At the moment, userID is used for all GUI dummy data
  final String userID;

  const ProfilePage({super.key, required this.userID});

  /// Style for the button bar
  static const buttonBarStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum _ProfileTabs { following, posts, followers }

class _ProfilePageState extends State<ProfilePage> {
  _ProfileTabs _currentTab = _ProfileTabs.posts;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // The entire page is a single CustomScrollView
        child: CustomScrollView(
          slivers: buildSliverLister(),
        ),
      ),
    );
  }

  /// Constructs all of the features of the profile page
  List<Widget> buildSliverLister() {
    return [
      // Allows us to use standard widgets in the view
      SliverToBoxAdapter(
        child: Column(
          children: [
            buildAvatar(),
            buildName(),
            buildButtonBar(),
            const Divider(),
          ],
        ),
      ),
      buildSliverList(),
    ];
  }

  /// Constructs the avatar, which currently is a random color
  Widget buildAvatar() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: CircleAvatar(
            backgroundColor: ColorHelper.random(),
            minRadius: 100,
            maxRadius: 100));
  }

  /// Constructs the user's name and button to activate a QR code
  Widget buildName() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      // Everything below this is some weird hack to center a widget
      // but put an extra widget to the side of it
      // https://stackoverflow.com/questions/58164799/flutter-align-widget-to-centre-and-another-to-the-right-impossible
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.userID,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      onPressed: showQR, icon: const Icon(Icons.qr_code)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a pop up dialog menu that displays the user's QR code
  void showQR() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(widget.userID),
              content: SizedBox(
                height: 250,
                width: 250,
                child: QrImage(
                  data: widget.userID,
                  version: QrVersions.auto,
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 16),
                        )))
              ],
            ));
  }

  /// Builds the button bar to select what to display
  /// (Followers, Posts, Following)
  Widget buildButtonBar() {
    return IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        createStackedbutton(512, 'Followers', _ProfileTabs.followers),
        const VerticalDivider(),
        createStackedbutton(1024, 'Posts', _ProfileTabs.posts),
        const VerticalDivider(),
        createStackedbutton(128, 'Following', _ProfileTabs.following),
      ],
    ));
  }

  /// Creates a button for the button bar
  Widget createStackedbutton(int count, String context, _ProfileTabs tabToSet) {
    return TextButton(
        onPressed: () {
          setState(() {
            _currentTab = tabToSet;
          });
        },
        child: Column(
          children: [
            Text(
              count.toString(),
              style: ProfilePage.buttonBarStyle,
            ),
            Text(
              context,
              style: ProfilePage.buttonBarStyle,
            ),
          ],
        ));
  }

  /// Builds the list for the profile according to the current tab
  SliverList buildSliverList() {
    switch (_currentTab) {
      case _ProfileTabs.followers:
        return buildUserList();
      case _ProfileTabs.following:
        return buildUserList();
      case _ProfileTabs.posts:
        return buildPostList();
    }
  }

  /// Constructs a list of users with small avatar icons and name
  /// Clicking on a list entry will navigate to their profile
  SliverList buildUserList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 15,
        (context, index) => ListTile(
          // Profile is a random color right now
          leading: CircleAvatar(
              backgroundColor: ColorHelper.random(),
              minRadius: 20,
              maxRadius: 20),
          // Text is a random username right now
          title: Text(randomUsername(index)),
          // Tapping on an entry navigates to their profile
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(randomUsername(index)),
                  ),
                  body: ProfilePage(userID: randomUsername(index))),
              fullscreenDialog: true,
            ));
          },
        ),
      ),
    );
  }

  /// Builds a random seeded username for dummy data
  String randomUsername(int seed) {
    return 'Username@${Random(seed).nextInt(8000) + 1000}';
  }

  /// Builds a list of posts using PostCardBuilder
  SliverList buildPostList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => PostCardBuilder.buildPostCard(),
        childCount: 15,
      ),
    );
  }
}
