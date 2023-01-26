import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CenterItemHolder extends StatelessWidget {
  const CenterItemHolder({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        decoration: BoxDecoration(
          color: context.isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}