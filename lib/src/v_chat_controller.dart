import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dto/v_chat_login_dto.dart';
import 'dto/v_chat_register_dto.dart';
import 'models/v_chat_room.dart';
import 'models/v_chat_user.dart';
import 'modules/message/views/message_view.dart';
import 'modules/rooms/cubit/room_cubit.dart';
import 'services/auth_provider.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'services/socket_controller.dart';
import 'services/socket_service.dart';
import 'services/v_chat_app_service.dart';
import 'services/vchat_provider.dart';
import 'sqlite/db_provider.dart';
import 'utils/api_utils/dio/v_chat_sdk_exception.dart';
import 'utils/custom_widgets/create_single_chat_dialog.dart';
import 'utils/storage_keys.dart';
import 'utils/helpers/helpers.dart';
import 'utils/theme/v_chat_dark_theme.dart';
import 'utils/theme/v_chat_light_theme.dart';
import 'utils/theme/v_chat_theme.dart';
import 'utils/translator/v_chat_lookup_string.dart';

///this is the controller of vchat
///which create the chat or customize the design
class VChatController {
  VChatController._privateConstructor();

  static final VChatController _instance =
      VChatController._privateConstructor();

  static VChatController get instance => _instance;

  final _vChatControllerProvider = VChatProvider();

  final _authProvider = AuthProvider();

  /// **baseUrl** v chat  backend base url
  /// **appName** your app name to because we create a file in phone internal storage to save files
  /// the folder in Documents/`appName`
  /// **isUseFirebase** if firebase not supported in your country or you not connect the app with firebase yet
  /// **lightTheme** define and override v_chat default Light theme
  /// **darkTheme** define and override v_chat default Dark theme
  /// **navKey** nav Key to get the context any where and support localization
  /// **maxMediaUploadSize** file videos images max size in byes   50 * 1000 * 1000 ~ 50mb
  Future init({
    required Uri baseUrl,
    required String appName,
    required bool isUseFirebase,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    VChatTheme? vChatTheme,
    required bool enableLogger,
    required GlobalKey<NavigatorState> navigatorKey,
    int maxMediaUploadSize = 50 * 1000 * 1000,
  }) async {
    await VChatAppService.to.init(isUseFirebase);

    await LocalStorageService.to.init();
    final appService = VChatAppService.to;

    appService.dark = darkTheme;
    appService.vChatTheme = vChatTheme;
    appService.light = lightTheme;
    if (darkTheme == null) {
      appService.dark = vChatDarkTheme.copyWith();
    }
    if (lightTheme == null) {
      appService.light = vChatLightTheme;
    }

    appService.navKey = navigatorKey;
    appService.isUseFirebase = isUseFirebase;

    appService.appName = appName;
    appService.maxMediaSize = maxMediaUploadSize;
    appService.baseUrl = baseUrl.toString();
    late bool enableLog;
    if (kReleaseMode) {
      enableLog = false;
    } else {
      enableLog = enableLogger;
    }
    appService.enableLog = enableLog;
  }

  /// to add new language to v chat
  void setLocaleMessages(
      {required String languageCode,
      String? countryCode,
      required VChatLookupString lookupMessages}) {
    try {
      if (countryCode == null) {
        VChatAppService.to.setLocaleMessages(languageCode, lookupMessages);
      } else {
        VChatAppService.to.setLocaleMessages(
            "${languageCode}_${countryCode.toUpperCase()}", lookupMessages);
      }
    } catch (err) {
      Helpers.vlog("you should call function after init v chat");
      throw "you should call function after init v chat";
    }
  }

  /// **throw** No internet connection
  Future<String> stopAllNotification() async {
    if (VChatAppService.to.isUseFirebase) {
      await FirebaseMessaging.instance.deleteToken();
      return VChatAppService.to
          .getTrans()
          .notificationsHasBeenStoppedSuccessfully();
    } else {
      throw "you have to enable firebase for this project first";
    }
  }

  /// **throw** No internet connection
  Future<String> enableAllNotification() async {
    if (VChatAppService.to.isUseFirebase) {
      final token = (await FirebaseMessaging.instance.getToken()).toString();
      return await _vChatControllerProvider.updateUserFcmToken(token);
    } else {
      throw "you have to enable fire base for this project first";
    }
  }

  /// **throw** No internet connection
  Future updateUserName({required String name}) async {
    return await _vChatControllerProvider.updateUserName(name: name);
  }

  /// **throw** File Not Found !
  /// **throw** No internet connection
  Future updateUserImage({required String imagePath}) async {
    return await _vChatControllerProvider.updateUserImage(path: imagePath);
  }

  /// **throw** No internet connection
  Future updateUserPassword(
      {required String oldPassword, required String newPassword}) async {
    return await _vChatControllerProvider.updateUserPassword(
        oldPassword: oldPassword, newPassword: newPassword);
  }

  /// when you call this function the user will be online and can receive notification
  /// first you have to login or register in v chat other wise will throw Exception
  void bindChatControllers() {
    if (VChatAppService.to.vChatUser == null) {
      throw VChatSdkException(
          "You must login or register to v chat first delete the app and login again !");
    }
    SocketService.to.init(SocketController());
    NotificationService.to.init();
    unawaited(RoomCubit.instance.getRoomsFromLocal());
  }

  /// **throw** User already in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> register(VChatRegisterDto dto) async {
    if (VChatAppService.to.isUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app ";
    }
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    VChatAppService.to.setUser(user);
    await Future.delayed(Duration.zero);
    bindChatControllers();
    return user;
  }

  /// **throw** You cant start chat if you start chat your self
  /// **throw** Exception if peer Email Not in v chat Data base ! so first you must migrate all users
  /// **throw** No internet connection
  Future<dynamic> createSingleChat({
    required String peerEmail,
    BuildContext? ctx,
    String? titleTxt,
    String? createBtnTxt,
  }) async {
    final data = await _vChatControllerProvider.createSingleChat(peerEmail);

    if (data == false) {
      /// No rooms founded
      /// create new Room
      final res = await showDialog<String>(
        context: ctx ?? VChatAppService.to.navKey!.currentContext!,
        builder: (context) {
          return CreateSingleChatDialog(
            createBtnTxt: createBtnTxt,
            titleTxt: titleTxt,
          );
        },
      );
      if (res != null && res.isNotEmpty) {
        final data =
            await _vChatControllerProvider.createNewSingleRoom(res, peerEmail);

        /// room has been created successfully
        await Future.delayed(const Duration(seconds: 1));
        _navigateToRoomMessage(
          data,
          ctx ?? VChatAppService.to.navKey!.currentContext!,
        );
      }
    } else {
      /// there are room open the chat page
      return await _navigateToRoomMessage(
        data,
        ctx ?? VChatAppService.to.navKey!.currentContext!,
      );
    }
  }

  Future<dynamic> _navigateToRoomMessage(
      dynamic data, BuildContext context) async {
    final room = VChatRoom.fromMap(data);

    RoomCubit.instance.currentRoomId = room.id;
    RoomCubit.instance.updateOneRoomInRamAndSort(room);

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageView(
          roomId: room.id,
        ),
      ),
    );
  }

  /// **throw** User not in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> login(VChatLoginDto dto) async {
    if (VChatAppService.to.isUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app";
    }
    final user = await _authProvider.login(dto);
    await _saveUser(user);
    VChatAppService.to.setUser(user);
    await Future.delayed(Duration.zero);
    bindChatControllers();
    return user;
  }

  Future _saveUser(VChatUser user) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StorageKeys.KV_CHAT_MY_MODEL, value: jsonEncode(user.toMap()));
    VChatAppService.to.setUser(user);
  }

  /// **throw** No internet connection
  Future logOut() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      await _vChatControllerProvider.logOut();
    } catch (err) {
      //
    }
    SocketService.to.destroy();
    const storage = FlutterSecureStorage();
    await storage.delete(key: StorageKeys.KV_CHAT_MY_MODEL);
    await DBProvider.db.reCreateTables();
  }
}