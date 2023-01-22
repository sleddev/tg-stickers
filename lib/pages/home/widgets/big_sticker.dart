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
            padding: const EdgeInsets.all(65),
            child: GestureDetector(
              onTap: () => clipboard.copySticker(stickers.bigSticker!),
              onSecondaryTap: () => stickers.hideBigSticker(),
              child: Image.file(stickers.bigSticker!),
            ),
            
          ),
          child: Container(),
        ),
        
      ),
    );
  }
}

/*Widget bigSticker(File imageFile) {
  var c = getIt<Controller>();
  return GestureDetector(
    onTap: () => c.stickerAreaOverlay.value = Container(),
    onSecondaryTap: () => c.stickerAreaOverlay.value = Container(),
    child: Blur(
      blur: 10,
      overlay: Container(width: double.infinity, height: double.infinity, color: const Color(0x77000000) ,padding: const EdgeInsets.all(65), 
        child: TransparentImageButton.assets(
          imageFile,
          onTapInside: () async {
            var imageBytes = await imageFile.readAsBytes();
            var item = DataWriterItem(suggestedName: basename(imageFile.path));
            if (Platform.isWindows) {
              item.add(Formats.fileUri(imageFile.uri));
            } else {
              item.add(Formats.png(imageBytes));
            }
            await ClipboardWriter.instance.write([item]);
            c.infoToast('Sticker copied');
            Timer(const Duration(milliseconds: 1300), (() => c.hideToast()));
          },
          onTapOutside: () => c.stickerAreaOverlay.value = Container(),
          
        )
      ),
      child: Container(),
    )
    );
}*/