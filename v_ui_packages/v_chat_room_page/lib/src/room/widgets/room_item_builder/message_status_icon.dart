// import 'package:flutter/material.dart';
// import 'package:v_chat_room_page/src/room/shared/shared.dart';
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
//
// import '../../../../v_chat_room_page.dart';
//
// class MessageStatusIcon extends StatelessWidget {
//   final MessageEmitStatus messageStatus;
//   final bool isMeSender;
//   final bool isSeen;
//   final bool isDeliver;
//
//   const MessageStatusIcon({
//     Key? key,
//     required this.isMeSender,
//     required this.messageStatus,
//     required this.isDeliver,
//     required this.isSeen,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final themeData = context.vRoomTheme.vChatItemBuilder.lastMessageStatus;
//     if (!isMeSender) {
//       return const SizedBox.shrink();
//     }
//     if (isSeen) {
//       return _getBody(themeData.seenIcon);
//     }
//     if (isDeliver) {
//       return _getBody(themeData.deliverIcon);
//     }
//     return _getBody(
//       _getIcon(themeData),
//     );
//   }
//
//   Widget _getBody(Widget icon) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 3),
//       child: icon,
//     );
//   }
//
//   Widget _getIcon(VMsgStatusTheme themeData) {
//     switch (messageStatus) {
//       case MessageEmitStatus.serverConfirm:
//         return themeData.sendIcon;
//       case MessageEmitStatus.error:
//         return themeData.refreshIcon;
//       case MessageEmitStatus.sending:
//         return themeData.pendingIcon;
//     }
//   }
// }
