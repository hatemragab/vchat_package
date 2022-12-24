import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/chat.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RoomItemMsg extends StatelessWidget {
  final String msg;
  final bool isBold;

  const RoomItemMsg({
    Key? key,
    required this.msg,
    required this.isBold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.vRoomTheme.vChatItemBuilder;
    if (isBold) {
      return VTextParserWidget(
        text: msg,
        enableTabs: false,
        onMentionPress: (userId) {},
        maxLines: 1,
        textStyle: theme.unSeenLastMessageTextStyle,
      );
    }
    return VTextParserWidget(
      text: msg,
      enableTabs: false,
      onMentionPress: (userId) {},
      maxLines: 1,
      textStyle: theme.seenLastMessageTextStyle,
    );
  }
}