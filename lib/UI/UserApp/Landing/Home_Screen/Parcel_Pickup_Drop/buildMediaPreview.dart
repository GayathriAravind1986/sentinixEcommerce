import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/UI/UserApp/Landing/Home_Screen/widget/video_player_widget.dart';

class MediaPreviewWidget extends StatelessWidget {
  final List<File> mediaFiles;
  final VoidCallback onAddMedia;
  final Function(int) onRemoveMedia;

  const MediaPreviewWidget({
    super.key,
    required this.mediaFiles,
    required this.onAddMedia,
    required this.onRemoveMedia,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaFiles.isEmpty) {
      return GestureDetector(
        onTap: onAddMedia,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: appPrimaryColor),
            color: greyShade300 ?? Colors.grey.shade300,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate,
                    color: appPrimaryColor, size: 30),
                SizedBox(height: 8),
                Text("Add Images or Videos (Optional)",
                    style: TextStyle(color: appPrimaryColor)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Uploaded Media",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...mediaFiles.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                final isVideo = file.path.toLowerCase().endsWith('.mp4');
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isVideo
                            ? VideoPlayerWidget(videoFile: file)
                            : Image.file(
                                file,
                                width: 110,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stack) => Container(
                                  color: greyShade300 ?? Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.cancel,
                              color: redColor, size: 20),
                          onPressed: () => onRemoveMedia(index),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (mediaFiles.length < 3)
                GestureDetector(
                  onTap: onAddMedia,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appPrimaryColor),
                      color: greyShade300 ?? Colors.grey.shade300,
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: appPrimaryColor, size: 30),
                          SizedBox(height: 4),
                          Text("Add More",
                              style: TextStyle(color: appPrimaryColor)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
