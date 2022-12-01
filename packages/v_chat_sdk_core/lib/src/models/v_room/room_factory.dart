import 'package:v_chat_sdk_core/src/models/v_room/single_room/single_room.dart';

import '../../../v_chat_sdk_core.dart';
import '../v_message/db_tables_name.dart';
import 'base_room.dart';
import 'broadcast/broadcast_room.dart';
import 'group/group_room.dart';

abstract class RoomFactory {
  static BaseRoom createRoom(Map<String, dynamic> map) {
    if (map[RoomTable.columnRoomType] != null) {
      return _createLocalRoom(map);
    }
    final type = RoomType.values.byName(map['rT'] as String);
    switch (type) {
      case RoomType.s:
        return SingleRoom.fromMap(map);
      case RoomType.g:
        return GroupRoom.fromMap(map);
      case RoomType.b:
        return BroadcastRoom.fromMap(map);
    }
  }

  static BaseRoom _createLocalRoom(Map<String, dynamic> map) {
    final type =
        RoomType.values.byName(map[RoomTable.columnRoomType] as String);
    switch (type) {
      case RoomType.s:
        return SingleRoom.fromLocalMap(map);
      case RoomType.g:
        return GroupRoom.fromLocalMap(map);
      case RoomType.b:
        return BroadcastRoom.fromLocalMap(map);
    }
  }
}
