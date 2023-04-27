import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MyProjectMessagePageWrapper extends StatelessWidget {
  final VRoom room;

  const MyProjectMessagePageWrapper({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMessagePage(
      vRoom: room,
      vMessageConfig: VMessageConfig(
        googleMapsApiKey: "AzoisfXXXXXXXXXXXX",
        isCallsAllowed: false,
      ),
    );
  }
}