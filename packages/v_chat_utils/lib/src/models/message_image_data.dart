import '../../v_chat_utils.dart';

class VMessageImageData {
  VPlatformFileSource fileSource;
  int width;
  int height;

//<editor-fold desc="Data Methods">

  VMessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageImageData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => fileSource.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'MessageImageData{ fileSource: $fileSource, width: $width, height: $height,}';
  }

  bool get isFromPath => fileSource.filePath != null;

  bool get isFromBytes => fileSource.bytes != null;

  VMessageImageData copyWith({
    VPlatformFileSource? fileSource,
    int? width,
    int? height,
  }) {
    return VMessageImageData(
      fileSource: fileSource ?? this.fileSource,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'width': width,
      'height': height,
    };
  }

  factory VMessageImageData.fromMap(Map<String, dynamic> map) {
    return VMessageImageData(
      fileSource: VPlatformFileSource.fromMap(map),
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

  factory VMessageImageData.fromFakeData() {
    return VMessageImageData(
      fileSource: VPlatformFileSource.fromUrl(
        url: "https://picsum.photos/600/600",
        isFullUrl: true,
      ),
      width: 600,
      height: 600,
    );
  }

//</editor-fold>
}