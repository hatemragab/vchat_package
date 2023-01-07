import 'dart:convert';

import '../../../local_db/tables/message_table.dart';
import '../base_message/v_base_message.dart';
import 'custom_msg_att.dart';

class VCustomMessage extends VBaseMessage {
  final VCustomMsgAtt data;

  VCustomMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.messageStatus,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.messageType,
    required super.localId,
    required super.createdAt,
    required super.updatedAt,
    required super.replyTo,
    required super.seenAt,
    required super.deliveredAt,
    required super.forwardId,
    required super.deletedAt,
    required super.parentBroadcastId,
    required super.isStared,
    required this.data,
  });

  VCustomMessage.fromRemoteMap(super.map)
      : data = VCustomMsgAtt.fromMap(map['msgAtt'] as Map<String, dynamic>),
        super.fromRemoteMap();

  VCustomMessage.fromLocalMap(super.map)
      : data = VCustomMsgAtt.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': infoAtt.toMap()};
  // }

  @override
  Map<String, dynamic> toLocalMap() {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(data.toMap())
    };
  }
}