import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/src/service/events_daemon.dart';
import 'package:v_chat_sdk_core/src/service/notification_listener.dart';
import 'package:v_chat_sdk_core/src/service/offline_online_emitter_service.dart';
import 'package:v_chat_sdk_core/src/service/re_send_daemon.dart';
import 'package:v_chat_sdk_core/src/service/socket_status_service.dart';
import 'package:v_chat_sdk_core/src/service/v_app_lifecycle_state.dart';
import 'package:v_chat_sdk_core/src/user_apis/auth/auth.dart';
import 'package:v_chat_sdk_core/src/user_apis/room/room.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../v_chat_sdk_core.dart';
import 'models/controller/message_page_config.dart';

/// VChatController instance.
///
/// It must be initialized before used, otherwise an error is thrown.
///
/// ```dart
/// await VChatController.init(...)
/// ```
///
/// Use it:
///
/// ```dart
/// final i = VChatController.I;
/// ```
class VChatController {
  final _log = Logger('VChatController');

  ///singleton
  VChatController._();

  static final _instance = VChatController._();
  static late final VNotificationListener _vNotificationListener;

  static VChatController get I {
    assert(
      _instance._isControllerInit,
      'You must initialize the v chat controller instance before calling VChatController.I',
    );
    return _instance;
  }

  late final AuthApi authApi;
  late final RoomApi roomApi;
  final vAppLifecycleState = VAppLifecycleState();

  ///v chat variables
  late final ControllerHelper _helper;
  late final VChatConfig vChatConfig;
  late final VMessagePageConfig vMessagePageConfig;
  bool _isControllerInit = false;
  late final VNativeApi nativeApi;

  /// Initialize the [VChatController] instance.
  ///
  /// It's necessary to initialize before calling [VChatController.I]
  static Future<VChatController> init({
    required VChatConfig vChatConfig,
    VMessagePageConfig vMessagePageConfig = const VMessagePageConfig(),
  }) async {
    assert(
      !_instance._isControllerInit,
      'This controller is already initialized',
    );
    _instance._isControllerInit = true;
    _instance.vChatConfig = vChatConfig;
    _instance.vMessagePageConfig = vMessagePageConfig;
    await VAppPref.init();
    _instance._helper = await ControllerHelper.instance.init(
      _instance.vChatConfig,
    );
    _instance.nativeApi = await VNativeApi.init();
    _instance.authApi = AuthApi(
      _instance.nativeApi,
      _instance.vChatConfig,
    );
    _instance.roomApi = RoomApi(
      _instance.nativeApi,
      _instance.vChatConfig,
    );

    SocketController.instance.connect();
    _startServices();

    return _instance;
  }

  void listenToOpenFromNotification() async {
    _vNotificationListener.getOpenAppNotification();
  }

  void dispose() {
    _isControllerInit = false;
    vAppLifecycleState.dispose();
  }

  ///make sure you already login or already login to v chat
  bool connectToSocket() {
    final access = VAppPref.getHashedString(key: VStorageKeys.accessToken);
    if (access == null) {
      _log.warning(
        "You try to connect to socket with out login please make sure you call VChatController.instance.login first",
      );
      return false;
    }
    SocketController.instance.connect();
    return true;
  }

  void listenOnNotificationsClicks() {}

  static void _startServices() {
    ReSendDaemon().start();
    EventsDaemon().start();
    OfflineOnlineEmitterService().start();
    SocketStatusService();
    _vNotificationListener = VNotificationListener(
      _instance.nativeApi,
      _instance.vChatConfig,
    );
  }
}