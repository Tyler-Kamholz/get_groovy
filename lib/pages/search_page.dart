/// Name: Tyler, Dalton, Matthew
/// Date: December 14, 2022
/// Description: Creates a list of profiles made of users of the app. Includes a seach bar, and a qrscanner button.
/// The search bar allows you to search for a specific user, where as the qrsacnner button brings you to the
/// qr scanning page in order to make streamline the process.
/// Bugs: N/A
/// Reflection: The use of clickable user tiles makes it easy to navigate to user profiles. With the search bar it becomes
/// much easier to find profiles of friends and family. Something that could be improved could be the search functionality to
/// find people even if the displayname is a couple letters off, or has similarities to another displayname.
/// It would be useful if a friend decided not to use their usual displayname but used a derivation of it. The qr scanner button
/// is quite straight forward, as having a qr button on a search page, give the idea that its going to be a way to scan it.

import 'package:flutter/material.dart';
import 'package:getgroovy/database_helpers.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../themes/theme_provider.dart';
import '../widgets/user_list_tile.dart';
import 'package:getgroovy/widgets/qr_reader.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = ScrollController();
  TextEditingController textBoxController = TextEditingController();

  Future<List<User>>? _usersListFuture;

  @override
  void initState() {
    _usersListFuture = DatabaseHelpers.getAllUsers();
    super.initState();
  }

  //builds the page with the list, search bar, and button.
  //the search bar help to narrow down the results of the user list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context)
            .getCurrentTheme()
            .backgroundColor,
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Stack(
                  children: [
                    //creates the search bar which on change resets the list of users
                    TextField(
                      controller: textBoxController,
                      decoration: const InputDecoration(labelText: 'Search'),
                      onChanged: (value) {setState(() {
                        
                      });},
                    ),
                    //creates the Qr scanning button, which pushed the qrscanner onto the navigator
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QRViewExample()));
                            },
                            icon: const Icon(Icons.qr_code_scanner))),
                  ],
                )),
            Expanded(
              //builds the list of users based on whatever the search bar wants to look for. Works with filter
              //and the textbox controller
              child: FutureBuilder(
                future: _usersListFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    List<User> filtered = filter(snapshot.data!, textBoxController.text);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return UserListTile(
                            userID: filtered[index].userID,
                          );
                        }
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ));
  }

//Takes the list of users and narrows it down to the people with the displayNames that contain a string.
  List<User> filter(List<User> users, String filterString) {
    List<User> outputList = [];
    for(int i = 0; i < users.length; i++) {
      if(users[i].displayName.toLowerCase().contains(filterString.toLowerCase())) {
        outputList.add(users[i]);
      }
    }
    return outputList;
  }
}
