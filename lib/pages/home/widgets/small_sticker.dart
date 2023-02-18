import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/clipboard_provider.dart';
import '../../../providers/sticker_provider.dart';

class SmallSticker extends StatelessWidget {
  final File imageFile;
  final String emoji;

  const SmallSticker({required this.imageFile, required this.emoji, super.key});

  @override
  Widget build(BuildContext context) {
    final clipboard = Provider.of<ClipboardProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);

    ImageProvider image;
    try {
      image = ResizeImage(FileImage(imageFile), width: 128, allowUpscaling: true);
    } catch (e) {
      image = FileImage(imageFile);
    }

    return GestureDetector(
      onTap: () async {
        await clipboard.copySticker(imageFile);
      },
      onSecondaryTap: () {
        stickers.showBigSticker(imageFile, emoji);
      },
      child: Image(image: image, isAntiAlias: true, filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          image = FileImage(imageFile);
          return Image(image: image, isAntiAlias: true, filterQuality: FilterQuality.medium);
        }),
    );
  }
}