import 'dart:io';

import 'package:flutter/material.dart';
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

    return GestureDetector(
      onTap: () async {
        await clipboard.copySticker(imageFile);
      },
      onSecondaryTap: () {
        stickers.showBigSticker(imageFile);
      },
      child: Image.file(imageFile, isAntiAlias: true, filterQuality: FilterQuality.medium),
    );
  }
}