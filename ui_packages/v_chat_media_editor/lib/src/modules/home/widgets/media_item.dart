import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/image_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/video_item.dart';

import '../../../core/core.dart';
import 'file_item.dart';

class MediaItem extends StatelessWidget {
  final VoidCallback onCloseClicked;
  final Function(VBaseMediaEditor item) onDelete;
  final Function(VBaseMediaEditor item) onCrop;
  final Function(VBaseMediaEditor item) onStartDraw;
  final Function(VBaseMediaEditor item) onPlayVideo;
  final bool isProcessing;

  final VBaseMediaEditor mediaFile;

  const MediaItem({
    super.key,
    required this.mediaFile,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
    required this.isProcessing,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    if (isProcessing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator.adaptive(),
        ],
      );
    }
    if (mediaFile is VMediaEditorImage) {
      return ImageItem(
        image: mediaFile as VMediaEditorImage,
        onCloseClicked: onCloseClicked,
        onCrop: onCrop,
        onDelete: onDelete,
        onStartDraw: onStartDraw,
      );
    } else if (mediaFile is VMediaEditorVideo) {
      return VideoItem(
        video: mediaFile as VMediaEditorVideo,
        onCloseClicked: onCloseClicked,
        onPlayVideo: onPlayVideo,
        onDelete: onDelete,
      );
    } else {
      return FileItem(
        file: mediaFile as VMediaEditorFile,
        onCloseClicked: onCloseClicked,
        onDelete: onDelete,
      );
    }
  }

  Widget getImage() {
    const BoxFit? fit = null;
    if (mediaFile is VMediaEditorImage) {
      final m = mediaFile as VMediaEditorImage;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.fileSource.filePath!),
          fit: fit,
        );
      }
      if (m.data.isFromBytes) {
        return Image.memory(
          Uint8List.fromList(m.data.fileSource.bytes!),
          fit: fit,
        );
      }
    } else if (mediaFile is VMediaEditorVideo) {
      final m = mediaFile as VMediaEditorVideo;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.thumbImage!.fileSource.filePath!),
          fit: fit,
        );
      }
      return Container(
        color: Colors.black,
      );
    }
    return Container(
      color: Colors.black,
    );
  }
}
