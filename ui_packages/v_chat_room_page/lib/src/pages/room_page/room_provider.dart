import 'dart:async';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../assets/data/api_rooms.dart';
import '../../assets/data/local_rooms.dart';

class RoomProvider {
  final _localRoom = VChatController.I.nativeApi.local.room;
  final _remoteRoom = VChatController.I.nativeApi.remote.room;

  Future<List<VRoom>> getFakeLocalRooms() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [VRoom.fromLocalMap(fakeLocalRooms.first)];
  }

  Future<VPaginationModel<VRoom>> getLocalRooms() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return VPaginationModel<VRoom>(
      values: await _localRoom.getRooms(limit: 200),
      page: 1,
      limit: 200,
    );
  }

  Future<List<VRoom>> getFakeApiRooms() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    return [VRoom.fromMap(fakeApiRooms.first)];
  }

  Future<VPaginationModel<VRoom>> getApiRooms(
    VRoomsDto dto,
  ) async {
    final apiModel = await _remoteRoom.getRooms(dto);
    unawaited(_localRoom.cacheRooms(apiModel.values));
    return apiModel;
  }

  Future<VRoom?> getRoomById(String roomId) async {
    final localRoom = await _localRoom.getRoomById(roomId);
    if (localRoom != null) {
      return localRoom;
    }
    final apiRoom = await _remoteRoom.getRoomById(roomId);
    await _localRoom.safeInsertRoom(apiRoom);
    return null;
  }
}