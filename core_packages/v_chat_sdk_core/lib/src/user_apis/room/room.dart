import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/api_service/channel/channel_api_service.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class RoomApi {
  final VNativeApi _vNativeApi;
  final ControllerHelper _helper = ControllerHelper.instance;
  final VChatConfig _chatConfig;
  final _log = Logger('user_api.Room');

  ChannelApiService get _channelApiService => _vNativeApi.remote.room;

  RoomApi(
    this._vNativeApi,
    this._chatConfig,
  );

  Future<VRoom> getPeerRoom({
    required String peerIdentifier,
  }) async {
    return _channelApiService.getPeerRoom(peerIdentifier);
  }
}
