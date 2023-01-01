import 'dart:async';

import 'package:v_chat_input_ui/src/models/mention_with_photo.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../assets/data/api_messages.dart';
import '../../assets/data/local_messages.dart';

class MessageProvider {
  final _remoteMessage = VChatController.I.nativeApi.remote.message;
  final _localMessage = VChatController.I.nativeApi.local.message;
  final _localRoom = VChatController.I.nativeApi.local.room;
  final _remoteRoom = VChatController.I.nativeApi.remote.room;
  final _remoteProfile = VChatController.I.nativeApi.remote.profile;
  final _socket = VChatController.I.nativeApi.remote.socketIo;

  Future<List<VBaseMessage>> getFakeLocalMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fakeLocalMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getFakeApiMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return fakeApiMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getLocalMessages({
    required String roomId,
    String? lastId,
  }) async {
    return _localMessage.getRoomMessages(
      roomId: roomId,
      lastId: lastId,
    );
  }

  Future<List<VBaseMessage>> getApiMessages({
    required String roomId,
    required VRoomMessagesDto dto,
  }) async {
    final apiMessages = await _remoteMessage.getRoomMessages(
      roomId: roomId,
      dto: dto,
    );
    unawaited(_localMessage.cacheRoomMessages(apiMessages));
    return apiMessages;
  }

  void setSeen(String roomId) {
    _socket.emitSeenRoomMessages(roomId);
    unawaited(_localRoom.updateRoomUnreadToZero(roomId));
  }

  Future<DateTime> getLastSeenAt(String peerId) async {
    return _remoteProfile.getUserLastSeenAt(peerId);
  }

  Future<bool> checkGroupStatus(String roomId) async {
    return _remoteRoom.getGroupStatus(roomId);
  }

  Future<List<MentionWithPhoto>> onMentionRequireSearch(String text) async {
    //todo search
    return <MentionWithPhoto>[];
  }

  void emitTypingChanged(VSocketRoomTypingModel model) {
    return _socket.emitUpdateRoomStatus(model);
  }
}
