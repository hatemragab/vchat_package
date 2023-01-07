import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/message/core/types.dart';
import 'package:v_chat_room_page/src/message/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_room_page.dart';

class MessageStatusIcon extends StatelessWidget {
  final VBaseMessage vBaseMessage;
  final bool isMeSender;
  final VMessageCallback? onReSend;
  final bool isSeen;
  final bool isDeliver;

  const MessageStatusIcon({
    Key? key,
    required this.isMeSender,
    required this.vBaseMessage,
    required this.isDeliver,
    this.onReSend,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData =
        context.vMessageTheme.vMessageItemBuilder.messageSendingStatus;
    if (!isMeSender) {
      return const SizedBox.shrink();
    }
    if (isSeen) {
      return _getBody(themeData.seenIcon);
    }
    if (isDeliver) {
      return _getBody(themeData.deliverIcon);
    }
    return _getBody(
      _getIcon(themeData),
    );
  }

  Widget _getBody(Widget icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: icon,
    );
  }

  Widget _getIcon(VMsgStatusTheme themeData) {
    switch (vBaseMessage.messageStatus) {
      case MessageEmitStatus.serverConfirm:
        return themeData.sendIcon;
      case MessageEmitStatus.error:
        return InkWell(
          onTap: () {
            if (onReSend != null) {
              onReSend!(vBaseMessage);
            }
          },
          child: themeData.refreshIcon,
        );
      case MessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
