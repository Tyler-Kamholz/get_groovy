import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/database_helpers.dart';
import 'package:getgroovy/model/post_reaction.dart';
import 'package:getgroovy/widgets/tappable_emoji.dart';

class ReactionBar extends StatefulWidget {
  final String postID;

  const ReactionBar({required this.postID, Key? key}) : super(key: key);

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  static const _availableEmojis = ['👍', '😍', '🤨', '😯', '👎'];
  late Future<List<PostReaction>> _reactionFuture;
  Map<String, int> counts = {};

  @override
  void initState() {
    super.initState();
    _reactionFuture =
        DatabaseHelpers.getReactions(postID: widget.postID).then((value) {
      counts = PostReaction.organizeEmojiCounts(value);
      value.sort((a, b) => ((counts[a] ?? 0) - (counts[b] ?? 0)));
      return value;
    });
  }

  void reloadReactions() {
    setState(() {
      _reactionFuture =
          DatabaseHelpers.getReactions(postID: widget.postID).then((value) {
        counts = PostReaction.organizeEmojiCounts(value);
        value.sort((a, b) => ((counts[a] ?? 0) - (counts[b] ?? 0)));
        return value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: FutureBuilder(
          future: _reactionFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                onLongPress: showReactions,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: counts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == counts.length) {
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
                        highlighted: isUserIDInThisEmoji(snapshot.data!, snapshot.data![index].emoji, FirebaseAuth.instance.currentUser!.uid),
                        highlightOnTap: true,
                        emoji: snapshot.data![index].emoji,
                        onTap: () {setReaction(snapshot.data![index].emoji);}
                      );
                    }
                  },
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  bool isUserIDInThisEmoji(
      List<PostReaction> reactions, String emoji, String userID) {
    for (var element in reactions) {
      if(element.emoji == emoji && element.userID == userID) {
        return true;
      }
    }
    return false;
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
                          onTap: () {
                            setReaction(_availableEmojis[index]);
                            Navigator.of(context).pop();
                          },
                        )),
              )),
            ));
  }

  void setReaction(String emoji) {
    DatabaseHelpers.addReaction(
                                    postID: widget.postID,
                                    reaction: PostReaction(
                                        emoji: emoji,
                                        userID: FirebaseAuth
                                            .instance.currentUser!.uid))
                                .then((_) {
                              reloadReactions();
                            });
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
                itemCount: counts.length,
                itemBuilder: (context, index) {
                  var emoji = counts.keys.elementAt(index);
                  var count = counts[emoji];
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
