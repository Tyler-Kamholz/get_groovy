import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class PostCardBuilder {
  static Card buildPostCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              color: ColorHelper.random(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              "Song name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ]),
      ),
    );
  }
}