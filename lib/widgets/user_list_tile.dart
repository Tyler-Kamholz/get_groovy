/*
 *Name: Matthew, Tyler
 *Date: December 14, 2022
 *Description: Shows a user, good for lists
 *Bugs: N/A
 *Reflection: N/A
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getgroovy/database_helpers.dart';

import '../pages/profile_page.dart';
import '../themes/theme_provider.dart';

/// Widget to display user profiles
class UserListTile extends StatefulWidget {
  final String userID;
  late final Future<DocumentSnapshot<Map<String, dynamic>>> _userDocument;
  late final Future<Image?>? _imageFuture;

  UserListTile({required this.userID, super.key}) {
    _userDocument =
        FirebaseFirestore.instance.collection('users').doc(userID).get();
    _imageFuture = DatabaseHelpers.getProfilePictureURL(userID).then((value) {
      return value != null ? Image.network(value) : null;
    });
  }

  @override
  State<UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget._userDocument,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var name = snapshot.data!.data()!['display_name'];
          return ListTile(
            // Profile is a random color right now
            leading: FutureBuilder(
                future: widget._imageFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {}
                  return CircleAvatar(
                      backgroundImage:
                          snapshot.data != null ? snapshot.data!.image : null,
                      backgroundColor: Colors.red,
                      minRadius: 15,
                      maxRadius: 15);
                }),
            // Text is a random username right now
            title: Text(name),
            // Tapping on an entry navigates to their profile
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: Provider.of<ThemeProvider>(context)
                          .getCurrentTheme()
                          .navBarColor,
                      foregroundColor: Provider.of<ThemeProvider>(context)
                          .getCurrentTheme()
                          .textBoxTextColor,
                      title: Text(name),
                    ),
                    body: ProfilePage(userID: widget.userID)),
                fullscreenDialog: true,
              ));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
