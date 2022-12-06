import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../pages/profile_page.dart';
import '../themes/theme_provider.dart';

/// Widget to display user profiles
class UserListTile extends StatefulWidget {
  final String userID;
  late final Future<DocumentSnapshot<Map<String, dynamic>>> _userDocument;

  UserListTile({required this.userID, super.key}) {
    _userDocument =
        FirebaseFirestore.instance.collection('users').doc(userID).get();
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
