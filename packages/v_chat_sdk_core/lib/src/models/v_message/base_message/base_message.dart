import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:intl/intl.dart';
import 'package:objectid/objectid.dart';
import 'package:uuid/uuid.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../types/platforms.dart';
import '../core/message_factory.dart';

abstract class VBaseMessage {
  VBaseMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderImageThumb,
    required this.platform,
    required this.roomId,
    required this.content,
    required this.messageType,
    required this.localId,
    required this.createdAt,
    required this.updatedAt,
    required this.messageStatus,
    required this.replyTo,
    required this.seenAt,
    required this.deliveredAt,
    required this.forwardId,
    required this.deletedAt,
    required this.parentBroadcastId,
    required this.isStared,
  });

  //id will be changed if message get from remote
  String id;

  // sender data
  String senderId;
  String senderName;
  VFullUrlModel senderImageThumb;

  //which pla-from this message send through
  final String platform;
  String roomId;

  //message text from server
  String content;
  MessageType messageType;

  //serverConfirm,error,sending
  MessageSendingStatusEnum messageStatus;

  // only will have value if this message reply to another
  VBaseMessage? replyTo;
  String? seenAt;
  String? deliveredAt;

  //forward from message id
  String? forwardId;

  // when message deleted from all
  String? deletedAt;

  //if message send through broadcast
  String? parentBroadcastId;

  // unique message id that is used to unique the message access all messages
  // it good because the message id will changed
  String localId;

  //when the message was send
  String createdAt;
  final String updatedAt;

  // is user intent to delete this message
  bool isDeleted = false;
  bool isStared;

  VBaseMessage.fromRemoteMap(Map<String, dynamic> map)
      : id = map['_id'] as String,
        senderId = map['sId'] as String,
        senderName = map['sName'] as String,
        senderImageThumb = VFullUrlModel(map['sImg'] as String),
        platform = map['plm'] as String,
        forwardId = map['forId'] as String?,
        roomId = map['rId'] as String,
        isStared = map['isStared'] == null ? false : map['isStared'] as bool,
        content = map['c'] as String,
        messageType = MessageType.values.byName(map['mT'] as String),
        replyTo = map['rTo'] == null
            ? null
            : MessageFactory.createBaseMessage(
                map['rTo'] as Map<String, dynamic>,
              ),
        seenAt = map['sAt'] as String?,
        deliveredAt = map['dAt'] as String?,
        deletedAt = map['dltAt'] as String?,
        parentBroadcastId = map['pBId'] as String?,
        localId = map['lId'] as String,
        createdAt = map['createdAt'] as String,
        messageStatus = MessageSendingStatusEnum.serverConfirm,
        updatedAt = map['updatedAt'] as String;

  // from local
  VBaseMessage.fromLocalMap(Map<String, dynamic> map)
      : id = map[MessageTable.columnId] as String,
        senderId = map[MessageTable.columnSenderId] as String,
        senderName = map[MessageTable.columnSenderName] as String,
        senderImageThumb =
            VFullUrlModel(map[MessageTable.columnSenderImageThumb] as String),
        platform = map[MessageTable.columnPlatform] as String,
        roomId = map[MessageTable.columnRoomId] as String,
        isStared = (map[MessageTable.columnIsStar] as int) == 1,
        content = map[MessageTable.columnContent] as String,
        seenAt = map[MessageTable.columnSeenAt] as String?,
        replyTo = map[MessageTable.columnReplyTo] == null
            ? null
            : MessageFactory.createBaseMessage(
                jsonDecode(map[MessageTable.columnReplyTo] as String)
                    as Map<String, dynamic>,
              ),
        deliveredAt = map[MessageTable.columnDeliveredAt] as String?,
        forwardId = map[MessageTable.columnForwardId] as String?,
        deletedAt = map[MessageTable.columnDeletedAt] as String?,
        parentBroadcastId =
            map[MessageTable.columnParentBroadcastId] as String?,
        localId = map[MessageTable.columnLocalId] as String,
        createdAt = map[MessageTable.columnCreatedAt] as String,
        updatedAt = map[MessageTable.columnUpdatedAt] as String,
        messageStatus = MessageSendingStatusEnum.values
            .byName(map[MessageTable.columnMessageStatus] as String),
        messageType = MessageType.values
            .byName(map[MessageTable.columnMessageType] as String);

  Map<String, Object?> toLocalMap() {
    final map = {
      MessageTable.columnId: id,
      MessageTable.columnSenderId: senderId,
      MessageTable.columnSenderName: senderName,
      MessageTable.columnSenderImageThumb: senderImageThumb.originalUrl,
      MessageTable.columnPlatform: platform,
      MessageTable.columnRoomId: roomId,
      MessageTable.columnIsStar: isStared ? 1 : 0,
      MessageTable.columnContent: content,
      MessageTable.columnMessageType: messageType.name,
      MessageTable.columnReplyTo:
          replyTo == null ? null : jsonEncode(replyTo!.toLocalMap()),
      MessageTable.columnSeenAt: seenAt,
      MessageTable.columnDeliveredAt: deliveredAt,
      MessageTable.columnForwardId: forwardId,
      MessageTable.columnDeletedAt: deletedAt,
      MessageTable.columnMessageStatus: messageStatus.name,
      MessageTable.columnParentBroadcastId: parentBroadcastId,
      MessageTable.columnLocalId: localId,
      MessageTable.columnCreatedAt: createdAt,
      MessageTable.columnUpdatedAt: updatedAt,
    };
    return map;
  }

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('content', content),
      PartValue('localId', localId),
      PartValue('forwardLocalId', forwardId),
      PartValue(
        'messageType',
        messageType.name,
      ),
      PartValue(
        'replyToLocalId',
        replyTo == null || isForward ? null : replyTo!.localId,
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      other is VBaseMessage && localId == other.localId && id == other.id;

  @override
  int get hashCode => localId.hashCode ^ id.hashCode;

  ///Some Getters
  bool get isForward => forwardId != null;

  String get lastMessageTimeString =>
      DateFormat.jm().format(DateTime.parse(createdAt).toLocal());

  DateTime get createdAtDate => DateTime.parse(createdAt).toLocal();

  DateTime? get seenAtDate =>
      seenAt == null ? null : DateTime.parse(seenAt!).toLocal();

  DateTime? get deliveredAtDate =>
      deliveredAt == null ? null : DateTime.parse(deliveredAt!).toLocal();

  DateTime? get deletedAtDate =>
      deletedAt == null ? null : DateTime.parse(deletedAt!).toLocal();

  // String get seenAtTimeAgo {
  //   if (seenAt == null) return "---";
  //   return t.format(DateTime.parse(seenAt!).toLocal());
  // }

  bool get isMeSender => senderId == AppConstants.myProfile.baseUser.vChatId;

  bool get isFromBroadcast => parentBroadcastId != null;

  bool get isContainReply => replyTo != null;

  String get getTextTrans {
    return AppConstants.getMessageBody(this);
  }

  bool get isSending => messageStatus == MessageSendingStatusEnum.sending;

  bool get isServerConfirm =>
      messageStatus == MessageSendingStatusEnum.serverConfirm;

  bool get isSendingOrError => isSending || isSendError;

  bool get isSendError => messageStatus == MessageSendingStatusEnum.error;

  /// if Msg contain image
  bool get isImage => messageType == MessageType.image;

  bool get isInfo => messageType == MessageType.info;

  bool get isVideo => messageType == MessageType.video;

  bool get isLocation => messageType == MessageType.location;

  bool get isVoice => messageType == MessageType.voice;

  bool get isFile => messageType == MessageType.file;

  bool get isText => messageType == MessageType.text;

  bool get isAllDeleted => messageType == MessageType.allDeleted;

  @override
  String toString() {
    return 'BaseMessage{id: $id, senderId: $senderId, senderName: $senderName, senderImageThumb: $senderImageThumb, platform: $platform, roomId: $roomId, content: $content, messageType: $messageType, messageStatus: $messageStatus, replyTo: $replyTo, seenAt: $seenAt, deliveredAt: $deliveredAt, forwardId: $forwardId, deletedAt: $deletedAt, parentBroadcastId: $parentBroadcastId,  localId: $localId, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, isStared: $isStared}';
  }

  VBaseMessage.buildMessage({
    required this.content,
    required this.roomId,
    required this.messageType,
    this.forwardId,
    String? broadcastId,
    this.replyTo,
  })  : id = ObjectId().hexString,
        localId = Uuid().v4(),
        platform = Platforms.currentPlatform,
        createdAt = DateTime.now().toLocal().toIso8601String(),
        updatedAt = DateTime.now().toLocal().toIso8601String(),
        senderId = AppConstants.myProfile.baseUser.vChatId,
        isStared = false,
        senderName = AppConstants.myProfile.baseUser.fullName,
        senderImageThumb =
            AppConstants.myProfile.baseUser.userImages.smallImage,
        messageStatus = MessageSendingStatusEnum.sending,
        parentBroadcastId = broadcastId,
        deletedAt = null,
        seenAt = null,
        deliveredAt = null;

  Map<String, Object?> toRemoteMap() {
    return {
      "_id": id,
      "sId": senderId,
      "sName": senderName,
      "sImg": senderImageThumb.originalUrl,
      "plm": platform,
      "mT": messageType.name,
      "rId": roomId,
      "c": content,
      "isStared": isStared,
      "sAt": seenAt,
      "rTo": replyTo == null ? null : (replyTo!).toRemoteMap(),
      "lId": localId,
      "dAt": deliveredAt,
      "forId": forwardId,
      "dltAt": deletedAt,
      "pBId": parentBroadcastId,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    };
  }
}