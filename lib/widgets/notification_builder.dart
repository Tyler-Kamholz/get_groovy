import 'package:flutter/material.dart';

class NotificationsBuilder {
  static Widget buildPostCard() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Divider(
            thickness: 1,
          )
        ]);
  }
}
