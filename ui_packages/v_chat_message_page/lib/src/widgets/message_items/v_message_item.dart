import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/direction_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_broadcast_icon.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_status_icon.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_time_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/v_message_item_controller.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/all_deleted_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/call_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/custom_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/file_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/image_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/info_message.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/location_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/text_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/video_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/voice_message_item.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMessageItem extends StatelessWidget {
  final VBaseMessage message;
  final VMessageItemController itemController;
  final Function(String userId) onMentionPress;

  const VMessageItem({
    Key? key,
    required this.message,
    required this.itemController,
    required this.onMentionPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //we have date divider holder
    //we have normal holder
    //we have info holder
    return InkWell(
      onLongPress: () {
        itemController.onMessageItemLongPress(message);
      },
      onTap: () {
        itemController.onMessageItemPress(message);
      },
      child: DirectionItemHolder(
        isMeSender: message.isMeSender,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _getChild(message),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MessageBroadcastWidget(
                  isFromBroadcast: message.isFromBroadcast,
                ),
                MessageTimeWidget(
                  dateTime: message.createdAtDate,
                ),
                MessageStatusIcon(
                  isDeliver: message.deliveredAt != null,
                  isSeen: message.seenAt != null,
                  isMeSender: message.isMeSender,
                  messageStatus: message.messageStatus,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getChild(VBaseMessage message) {
    switch (message.messageType) {
      case MessageType.text:
        return TextMessageItem(
          message: message as VTextMessage,
          onLinkPress: itemController.onLinkPress,
          onEmailPress: itemController.onEmailPress,
          onMentionPress: onMentionPress,
          onPhonePress: itemController.onPhonePress,
        );
      case MessageType.image:
        return ImageMessageItem(
          message: message as VImageMessage,
        );
      case MessageType.file:
        return FileMessageItem(
          message: message as VFileMessage,
        );
      case MessageType.video:
        return VideoMessageItem(
          message: message as VVideoMessage,
        );
      case MessageType.voice:
        return VoiceMessageItem(
          message: message as VVoiceMessage,
        );
      case MessageType.location:
        return LocationMessageItem(
          message: message as VLocationMessage,
        );
      case MessageType.allDeleted:
        return AllDeletedItem(
          message: message as VAllDeletedMessage,
        );
      case MessageType.call:
        return CallMessageItem(
          message: message as VCallMessage,
        );
      case MessageType.custom:
        return CustomMessageItem(
          message: message as VCustomMessage,
        );
      case MessageType.info:
        return InfoMessageItem(
          message: message as VInfoMessage,
        );
    }
  }
}