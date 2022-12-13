/// Name: Tyler, Dalton, Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: N/A

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
                    TextField(
                      controller: textBoxController,
                      decoration: const InputDecoration(labelText: 'Search'),
                      onChanged: (value) {setState(() {
                        
                      });},
                    ),
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
