import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getgroovy/widgets/tappable_emoji.dart';

class ReactionBar extends StatefulWidget {
  const ReactionBar({Key? key}) : super(key: key);

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  static const _availableEmojis = ['👍', '😍', '🤨', '😯', '👎'];
  late Map<String, int> _reactions;

  _ReactionBarState() {
    var random = Random();
    int numReactions = random.nextInt(_availableEmojis.length);
    _reactions = {};
    var curAvailableEmojis = List.from(_availableEmojis);
    for (int i = 0; i < numReactions; i++) {
      int chosenIndex = random.nextInt(curAvailableEmojis.length);
      var chosenEmoji = curAvailableEmojis[chosenIndex];
      _reactions[chosenEmoji] = random.nextInt(50);
      curAvailableEmojis.removeAt(chosenIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: InkWell(
        onLongPress: showReactions,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _reactions.length + 1,
            itemBuilder: ((context, index) {
              if (index == _reactions.length) {
                return InkWell(
                  onTap: addReaction,
                  customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(Icons.add_reaction),
                  ),
                );
              } else {
                return TappableEmoji(
                  initialHighlighted: false,
                  highlightOnTap: true,
                  emoji: _reactions.keys.elementAt(index),
                  onTap: (emoji) {},
                );
              }
            })),
      ),
    );
  }

  void addReaction() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a reaction'),
              content: SizedBox(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    _availableEmojis.length,
                    (index) => TappableEmoji(
                          emoji: _availableEmojis[index],
                          highlightOnTap: false,
                          onTap: (emoji) {
                            setState(() {
                              _reactions[emoji] = (_reactions[emoji] ?? 0) + 1;
                            });
                            Navigator.of(context).pop();
                          },
                        )),
              )),
            ));
  }

  void showReactions() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Reactions'),
            content: SizedBox(
              height: 200,
              width: 100,
              child: ListView.builder(
                itemCount: _reactions.length,
                itemBuilder: (context, index) {
                  var emoji = _reactions.keys.elementAt(index);
                  var count = _reactions[emoji];
                  return ListTile(
                    title: Text(
                      '$emoji $count',
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                },
              ),
            )));
  }
}
