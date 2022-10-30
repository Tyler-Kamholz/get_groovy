import 'package:flutter/material.dart';

class TappableEmoji extends StatefulWidget {
  final String emoji;
  final void Function(String emoji)? onTap;
  final bool highlightOnTap;
  final bool initialHighlighted;

  const TappableEmoji({Key? key, required this.emoji, this.onTap, this.initialHighlighted = false, this.highlightOnTap = false}) : super(key: key);

  @override
  State<TappableEmoji> createState() => _TappableEmojiState();
}

class _TappableEmojiState extends State<TappableEmoji> {
  late bool _highlighted;


  @override
  void initState() {
    super.initState();
    _highlighted = widget.initialHighlighted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: _highlighted ? Colors.lightBlue.withAlpha(128) : null,
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)),
        onTap: () {
          if(widget.onTap != null) {
            widget.onTap!(widget.emoji);
          }
          if(widget.highlightOnTap) {
            setState(() {
              _highlighted ^= true;
            });
          }

        },
        child: Center(
          child: Text(
            widget.emoji,
            style: const TextStyle(fontSize: 20),
        )),
      ),
    );
  }
}