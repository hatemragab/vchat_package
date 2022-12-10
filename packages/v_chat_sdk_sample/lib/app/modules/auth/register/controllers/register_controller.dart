import 'package:animated_login/src/models/login_data.dart';
import 'package:animated_login/src/models/signup_data.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/enums.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_pick.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

import '../../../../core/repository/user.repository.dart';
import '../../../../core/utils/app_alert.dart';
import '../../../../core/utils/app_pref.dart';
import '../../authenticate.dart';

class RegisterController extends GetxController {
  final UserRepository repository;

  RegisterController(this.repository);

  PlatformFileSource? userImage;

  void getImage() async {
    final userImage = await AppPick.getCroppedImage();
    if (userImage != null) {
      this.userImage = userImage;
    }
    update();
  }

  Future<String?> onLogin(LoginData loginData) async {
    try {
      final user = await AuthRepo.loginWithEmailAndPassword(
          loginData.email, loginData.password);
      final userFromFire = await repository.getId(user.uid);
      await AppPref.setMap(StorageKeys.myProfile, userFromFire.toMap());
      Get.offAndToNamed(Routes.HOME);
    } catch (err) {
      AppAlert.showErrorSnackBar(msg: err.toString());
      print(err);
      return err.toString();
    }
    return null;
  }

  Future<String?> onSignup(SignUpData signUpData) async {
    try {
      // AppAlert.showLoading();
      final user = await AuthRepo.signUpWithEmailAndPassword(
        emailAddress: signUpData.email,
        password: signUpData.password,
      );
      final userFromFire = UserModel(
        uid: user.uid,
        userName: signUpData.name,
        createdAt: DateTime.now().toUtc(),
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/v-chat-sdk-v2.appspot.com/o/images%2Fdefault_user_image.png?alt=media&token=13bd6095-614f-42d2-a626-0fbbb0668d3c",
      );
      await repository.add(userFromFire);
      await AppPref.setMap(StorageKeys.myProfile, userFromFire.toMap());
      Get.offAndToNamed(Routes.HOME);
    } catch (err) {
      AppAlert.showErrorSnackBar(msg: err.toString());
      print(err);
      //AppAlert.hideLoading();
      return err.toString();
    }
    return null;
  }
}