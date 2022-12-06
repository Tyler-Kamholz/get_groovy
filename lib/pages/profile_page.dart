import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database_helpers.dart';
import '../model/post.dart';
import '../spotify/spotify_provider.dart';
import '../themes/theme_provider.dart';
import '../widgets/post_card_builder.dart';
import '../widgets/user_list_tile.dart';

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
  late Future<List<Post>> _postsFuture;
  late Future<List<String>> _followingFuture;
  late Future<List<String>> _followersFuture;
  @override
  void initState() {
    super.initState();
    _updateUserDocument();

    _postsFuture = DatabaseHelpers.getPosts(widget.userID);
    _followingFuture = DatabaseHelpers.getFollowing(widget.userID);
    _followersFuture = DatabaseHelpers.getFollowers(widget.userID);
  }

  _ProfileTabs _currentTab = _ProfileTabs.posts;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeProvider>(context).getCurrentTheme().backgroundColor,
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

  /// Constructs the avatar , which currently is a random color
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
                color: Provider.of<ThemeProvider>(context)
                    .getCurrentTheme()
                    .iconColor,
                icon: const Icon(Icons.edit),
                /// Pushes to Create Profile Picture Page
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePicture(title: '',))); 
                },
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
  /// and follow/unfollow or edit username button
  Widget buildName(DocumentSnapshot<Map<String, dynamic>> userData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: () {
              if (widget.isMe) {
                return IconButton(
                  color: Provider.of<ThemeProvider>(context)
                      .getCurrentTheme()
                      .iconColor,
                  icon: const Icon(Icons.edit),
                  onPressed: _editDisplayName,
                );
              } else {
                return FutureBuilder(
                  future: DatabaseHelpers.isXFollowingY(
                      FirebaseAuth.instance.currentUser!.uid, widget.userID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return IconButton(
                          icon: const Icon(Icons.person_remove),
                          onPressed: () {
                            DatabaseHelpers.unfollow(
                                    follower:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    following: widget.userID)
                                .then((value) {
                              _updateUserDocument();
                            });
                          },
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: () {
                            DatabaseHelpers.follow(
                                    follower:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    following: widget.userID)
                                .then((value) {
                              _updateUserDocument();
                            });
                          },
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                );
              }
            }()),
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
                      color: Provider.of<ThemeProvider>(context)
                          .getCurrentTheme()
                          .iconColor,
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
        FutureBuilder(
          future: _followersFuture,
          builder: (context, snapshot) => createStackedbutton(
              snapshot.hasData ? snapshot.data!.length : 0,
              'Followers',
              _ProfileTabs.followers,
              context),
        ),
        const VerticalDivider(),
        FutureBuilder(
          future: _postsFuture,
          builder: (context, snapshot) => createStackedbutton(
              snapshot.hasData ? snapshot.data!.length : 0,
              'Posts',
              _ProfileTabs.posts,
              context),
        ),
        const VerticalDivider(),
        FutureBuilder(
          future: _followingFuture,
          builder: (context, snapshot) => createStackedbutton(
              snapshot.hasData ? snapshot.data!.length : 0,
              'Following',
              _ProfileTabs.following,
              context),
        ),
      ],
    ));
  }

  /// Creates a button for the button bar
  Widget createStackedbutton(
      int count, String text, _ProfileTabs tabToSet, BuildContext context) {
    return TextButton(
        onPressed: () {
          if (_currentTab != tabToSet) {
            setState(() {
              _currentTab = tabToSet;
            });
          }
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
        return buildUserList(followers: true);
      case _ProfileTabs.following:
        return buildUserList(followers: false);
      case _ProfileTabs.posts:
        return buildPostList();
    }
  }

  /// Constructs a list of users with small avatar icons and name
  /// Clicking on a list entry will navigate to their profile
  Widget buildUserList({required bool followers}) {
    return FutureBuilder(
      future: followers ? _followersFuture : _followingFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return UserListTile(
                  userID: snapshot.data![index],
                );
              },
              childCount: snapshot.data!.length,
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container();
              },
              childCount: 0,
            ),
          );
        }
      },
    );
  }

  /// Builds a list of posts using PostCardBuilder
  Widget buildPostList() {
    return FutureBuilder(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                //print(snapshot.data?.docs);
                return PostCardWidget(
                  post: snapshot.data![index],
                  provider: Provider.of<SpotifyProvider>(context),
                );
              },
              childCount: snapshot.data!.length,
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container();
              },
              childCount: 0,
            ),
          );
        }
      },
    );
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
