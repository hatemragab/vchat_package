import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ImageItem extends StatelessWidget {
  final VMediaImageRes image;
  final VoidCallback onCloseClicked;
  final Function(VMediaImageRes item) onDelete;
  final Function(VMediaImageRes item) onCrop;
  final Function(VMediaImageRes item) onStartDraw;

  const ImageItem(
      {Key? key,
      required this.image,
      required this.onCloseClicked,
      required this.onDelete,
      required this.onCrop,
      required this.onStartDraw})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: onCloseClicked,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(image),
                      icon: const Icon(
                        PhosphorIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        if (VPlatforms.isWeb) {
                          return;
                        }
                        onCrop(image);
                      },
                      icon: Icon(
                        PhosphorIcons.crop,
                        color: VPlatforms.isWeb ? Colors.grey : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        if (VPlatforms.isWeb) {
                          return;
                        }
                        onStartDraw(image);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: VPlatforms.isWeb ? Colors.grey : Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: VPlatformCacheImageWidget(
            source: image.data.fileSource,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
