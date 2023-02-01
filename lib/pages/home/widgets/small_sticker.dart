import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/clipboard_provider.dart';

import '../../../providers/sticker_provider.dart';

class SmallSticker extends StatelessWidget {
  final File imageFile;

  const SmallSticker({required this.imageFile, super.key});

  @override
  Widget build(BuildContext context) {
    final clipboard = Provider.of<ClipboardProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);

    String emoji;
    try {
      emoji = basename(imageFile.path).split('-').last.split('.')[0];
    } catch (e) {
      emoji = '';
    }

    ImageProvider image = ResizeImage(FileImage(imageFile), width: 128, allowUpscaling: true);

    return GestureDetector(
      onTap: () async {
        await clipboard.copySticker(imageFile);
      },
      onSecondaryTap: () {
        stickers.showBigSticker(imageFile, emoji);
      },
      child: Image(image: image, isAntiAlias: true, filterQuality: FilterQuality.medium,),
    );
  }
}