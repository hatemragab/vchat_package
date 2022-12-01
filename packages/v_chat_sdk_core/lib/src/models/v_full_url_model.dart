import '../../v_chat_sdk_core.dart';

class VFullUrlModel {
  final String originalUrl;
  late final String fullUrl;

  VFullUrlModel(this.originalUrl) {
    fullUrl = "${AppConstants.getMediaBaseUrl}$originalUrl";
  }

  // to String
  @override
  String toString() {
    return originalUrl;
  }
}
