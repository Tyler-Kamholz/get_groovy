/*
 *Name: Matthew
 *Date: December 14, 2022
 *Description: A widget that shows an emoji, and has an ontap
  As well as automatically highlighting. 
 *Bugs: N/A
 *Reflection: N/A
*/

import 'package:flutter/material.dart';

class TappableEmoji extends StatefulWidget {
  final String emoji;
  final void Function()? onTap;
  final bool highlightOnTap;
  final bool highlighted;

  const TappableEmoji(
      {Key? key,
      required this.emoji,
      this.onTap,
      this.highlighted = false,
      this.highlightOnTap = false})
      : super(key: key);

  @override
  State<TappableEmoji> createState() => _TappableEmojiState();
}

class _TappableEmojiState extends State<TappableEmoji> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: widget.highlighted ? Colors.lightBlue.withAlpha(128) : null,
      ),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        onTap: widget.onTap,
        child: Center(
            child: Text(
          widget.emoji,
          style: const TextStyle(fontSize: 20),
        )),
      ),
    );
  }
}
