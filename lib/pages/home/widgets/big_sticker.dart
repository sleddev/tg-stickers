import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/sticker_provider.dart';

import '../../../providers/clipboard_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils.dart';

class BigSticker extends StatefulWidget {

  const BigSticker({super.key});

  @override
  State<BigSticker> createState() => _BigStickerState();
}

//TODO: custom image implementation, that only renders image files, and downscales them

class _BigStickerState extends State<BigSticker> {
  @override
  Widget build(BuildContext context) {
    final stickers = Provider.of<StickerProvider>(context);
    final clipboard = Provider.of<ClipboardProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    return stickers.bigSticker == null ? Container() :
    Fade(
      duration: stickers.bigStickerTransition,
      notifier: stickers.bigStickerVisible,
      child: GestureDetector(
        onTap: () => stickers.hideBigSticker(),
        onSecondaryTap: () => stickers.hideBigSticker(),
        child: Blur(
          blur: 10,
          overlay: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.blurColor,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 65,
                  child: Text(
                    stickers.bigStickerEmoji!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 65, right: 65, bottom: 65),
                    child: GestureDetector(
                      onTap: () => clipboard.copySticker(stickers.bigSticker!),
                      onSecondaryTap: () => stickers.hideBigSticker(),
                      child: Image(image: ResizeImage(FileImage(stickers.bigSticker!), width: 246), isAntiAlias: true, filterQuality: FilterQuality.medium,),
                    ),
                    
                  ),
                ),
              ],
            ),
          ),
          child: Container(),
        ),
        
      ),
    );
  }
}
