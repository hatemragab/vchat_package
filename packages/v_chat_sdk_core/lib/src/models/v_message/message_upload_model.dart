import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

class MessageUploadModel {
  final List<PartValue> body;
  final http.MultipartFile? file1;
  final http.MultipartFile? file2;
  final String roomId;
  final String msgLocalId;

  const MessageUploadModel({
    required this.body,
    required this.roomId,
    required this.msgLocalId,
    this.file1,
    this.file2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageUploadModel &&
          runtimeType == other.runtimeType &&
          msgLocalId == other.msgLocalId;

  @override
  int get hashCode => msgLocalId.hashCode;
}
