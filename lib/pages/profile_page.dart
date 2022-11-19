import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/dummy_data.dart';
import 'package:getgroovy/helpers/helpers.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/post_card_builder.dart';

/// Widget to display user profiles
class ProfilePage extends StatefulWidget {
  final String userID;
  late final bool isMe;

  ProfilePage({super.key, required this.userID}) {
    isMe = FirebaseAuth.instance.currentUser!.uid == userID;
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum _ProfileTabs { following, posts, followers }

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDocument;
  late Future<QuerySnapshot<Map<String, dynamic>>> _songListFuture;
  @override
  void initState() {
    super.initState();
    _updateUserDocument();
    _songListFuture = FirebaseFirestore.instance
        .collection('posts')
        .where('user_id', isEqualTo: widget.userID)
        .get();
  }

  _ProfileTabs _currentTab = _ProfileTabs.posts;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          // The entire page is a single CustomScrollView
          child: FutureBuilder(
        future: _userDocument,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return CustomScrollView(
              slivers: buildSliverLister(snapshot.data!),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }

  /// Constructs all of the features of the profile page
  List<Widget> buildSliverLister(
      DocumentSnapshot<Map<String, dynamic>> userData) {
    return [
      // Allows us to use standard widgets in the view
      SliverToBoxAdapter(
        child: Column(
          children: [
            buildAvatar(),
            buildName(userData),
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
    return Stack(children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: CircleAvatar(
            backgroundColor: Colors.red, minRadius: 100, maxRadius: 100),
      ),
      Positioned(
          bottom: 0,
          right: 0,
          child: () {
            if (widget.isMe) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              );
            } else {
              return const SizedBox(
                width: 10,
                height: 10,
              );
            }
          }())
    ]);
  }

  /// Constructs the user's name and button to activate a QR code
  Widget buildName(DocumentSnapshot<Map<String, dynamic>> userData) {
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
            Expanded(
                child: widget.isMe
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editDisplayName,
                      )
                    : IconButton(
                        icon: const Icon(Icons.person_add),
                        onPressed: () {},
                      )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(userData['display_name'],
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
                      onPressed: () {
                        showQR(userData['display_name'], userData['user_id']);
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

  /// Displays a pop up dialog menu that displays the user's QR code
  void showQR(String displayName, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(displayName),
              content: SizedBox(
                height: 250,
                width: 250,
                child: QrImage(
                  data: userId,
                  version: QrVersions.auto,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
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
        createStackedbutton(512, 'Followers', _ProfileTabs.followers, context),
        const VerticalDivider(),
        createStackedbutton(1024, 'Posts', _ProfileTabs.posts, context),
        const VerticalDivider(),
        createStackedbutton(128, 'Following', _ProfileTabs.following, context),
      ],
    ));
  }

  /// Creates a button for the button bar
  Widget createStackedbutton(
      int count, String text, _ProfileTabs tabToSet, BuildContext context) {
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
              style: _getButtonBarStyle(context),
            ),
            Text(
              text,
              style: _getButtonBarStyle(context),
            ),
          ],
        ));
  }

  /// Builds the list for the profile according to the current tab
  Widget buildSliverList() {
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
      delegate: SliverChildBuilderDelegate(childCount: 15, (context, index) {
        var name = DummyData.getRandomName();
        return ListTile(
          // Profile is a random color right now
          leading: CircleAvatar(
              foregroundImage:
                  Image.asset('images/image${Random().nextInt(7) + 1}.jpg')
                      .image,
              backgroundColor: ColorHelper.random(),
              minRadius: 20,
              maxRadius: 20),
          // Text is a random username right now
          title: Text(name),
          // Tapping on an entry navigates to their profile
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(name),
                  ),
                  body: Container()), //const ProfilePage(user: null,)),
              fullscreenDialog: true,
            ));
          },
        );
      }),
    );
  }

  /// Builds a list of posts using PostCardBuilder
  Widget buildPostList() {
    return FutureBuilder(
      future: _songListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostCardBuilder.buildPostCard(
                    snapshot.data!.docs[index].data(), context);
              },
              childCount: snapshot.data!.docs.length,
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container();
            },
            childCount: 0,
          ),
        );
      },
    );

    /*
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(), //PostCardBuilder.buildPostCard(context),
        childCount: 15,
      ),
    );
    */
  }

  static TextStyle _getButtonBarStyle(BuildContext context) {
    switch (Theme.of(context).brightness) {
      case Brightness.dark:
        return const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );
      case Brightness.light:
        return const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
    }
  }

  void _editDisplayName() {
    TextEditingController updateNameController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Edit display name"),
              content: SizedBox(
                height: 250,
                width: 250,
                child: TextField(
                  controller: updateNameController,
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userID)
                              .set({
                            'display_name': updateNameController.text,
                          }, SetOptions(merge: true)).then((value) {
                            _updateUserDocument();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 16),
                        )))
              ],
            ));
  }

  void _updateUserDocument() {
    setState(() {
      _userDocument = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
    });
  }
}
