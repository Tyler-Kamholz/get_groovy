import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/helpers/helpers.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/post_card_builder.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  const ProfilePage({super.key, required this.userID});

  static const favStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const thingStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 24,
    color: Colors.black,
  );

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum _profileTabs { following, posts, followers }

class _ProfilePageState extends State<ProfilePage> {
  _profileTabs _currentTab = _profileTabs.posts;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: buildSliverLister(),
        ),
      ),
    );
  }

  List<Widget> buildSliverLister() {
    return <Widget>[
      SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: buildAvatar()),
            buildName(),
            buildButtonBar(),
            const Divider(),
          ],
        ),
      ),
      buildSliverList(),
    ];
  }

  Widget buildAvatar() {
    return CircleAvatar(
        backgroundColor: ColorHelper.random(), minRadius: 100, maxRadius: 100);
  }

  Widget buildName() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                    style: TextStyle(
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
                      onPressed: () {
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
                      },
                      icon: const Icon(Icons.qr_code)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonBar() {
    return IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        createStackedbutton(512, 'Following', () {
          setState(() {
            _currentTab = _profileTabs.followers;
          });
        }),
        const VerticalDivider(),
        createStackedbutton(1024, 'Posts', () {
          setState(() {
            _currentTab = _profileTabs.posts;
          });
        }),
        const VerticalDivider(),
        createStackedbutton(128, 'Followers', () {
          setState(() {
            _currentTab = _profileTabs.following;
          });
        }),
      ],
    ));
  }

  Widget createStackedbutton(int count, String context, Function onClick) {
    return TextButton(
        onPressed: () {
          onClick();
        },
        child: Column(
          children: [
            Text(
              count.toString(),
              style: ProfilePage.favStyle,
            ),
            Text(
              context,
              style: ProfilePage.favStyle,
            ),
          ],
        ));
  }

  SliverList buildSliverList() {
    switch (_currentTab) {
      case _profileTabs.followers:
        return buildUserList();
      case _profileTabs.following:
        return buildUserList();
      case _profileTabs.posts:
        return buildPostList();
    }
  }

  String randomUsername(int seed) {
    return 'Username@${Random(seed).nextInt(8000) + 1000}';
  }

  SliverList buildUserList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          leading: CircleAvatar(
              backgroundColor: ColorHelper.random(),
              minRadius: 20,
              maxRadius: 20),
          title: Text(randomUsername(index)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        childCount: 15,
      ),
    );
  }

  SliverList buildPostList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => PostCardBuilder.buildPostCard(),
        childCount: 15,
      ),
    );
  }

  Widget returnThing() {
    return Container(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Container()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.userID, style: TextStyle(fontSize: 32)),
            ],
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(onPressed: () {}, icon: Icon(Icons.qr_code)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
