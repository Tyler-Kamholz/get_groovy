import 'package:flutter/material.dart';
import 'package:getgroovy/widgets/post_card_builder.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Snap(
        controller: controller.appBar,
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return PostCardBuilder.buildPostCard(context);
          },
        ),
      ),
    );
  }
}
