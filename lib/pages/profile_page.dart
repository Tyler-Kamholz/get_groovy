import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getgroovy/main.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  final controller = ScrollController();

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Container(
            color: Colors.black,
            width: 200,
            height: 200,
            margin: EdgeInsets.all(20),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Container(
            color: Colors.green,
            width: 200,
            height: 20,
            child: const Text(
              textAlign: TextAlign.center,
              '@User_Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            //color: Colors.blue,
            width: 400,
            height: 400,
            child: Snap(
              controller: controller.appBar,
              child: ListView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      leading: const Text('Album Cover'),
                      title: const Text('this is where the songs will go'),
                      subtitle:
                          const Text('add to playlist goes here  with preview'),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
