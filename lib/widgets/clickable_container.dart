import 'package:flutter/material.dart';

class ClickableContainer extends StatelessWidget {
  final Widget child;
  final bool selected;
  final Function()? onTap;
  const ClickableContainer({required this.child, required this.selected, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color.fromARGB(25, 50, 50, 255) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
