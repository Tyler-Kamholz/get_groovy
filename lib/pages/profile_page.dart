import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/helpers/helpers.dart';

import '../widgets/post_card_builder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
  late final outerListChildren = <Widget>[
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
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Text('Bob Robertson',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )),
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

  SliverList buildUserList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(
          leading: CircleAvatar(
              backgroundColor: ColorHelper.random(), minRadius: 20, maxRadius: 20),
          title: Text('Username@${Random().nextInt(8000) + 1000}'),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onTap: () {},
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

  

  
}
