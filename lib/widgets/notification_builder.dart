/// Name: Tyler, Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: N/A

import 'package:flutter/material.dart';
import 'package:getgroovy/dummy_data.dart';

class NotificationsBuilder {
  // Returns the post card
  static Widget buildPostCard(String message) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      const Divider(
        thickness: 1,
      )
    ]);
  }
}
