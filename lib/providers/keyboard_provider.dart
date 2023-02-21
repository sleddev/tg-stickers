import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tgstickers/providers/clipboard_provider.dart';
import 'package:tgstickers/providers/sticker_provider.dart';

class KeyboardProvider {
  FocusNode focusNode = FocusNode(skipTraversal: true);
  FocusScopeNode scope = FocusScopeNode();

  StickerProvider stickers;
  ClipboardProvider clipboard;

  KeyboardProvider({required this.stickers, required this.clipboard});

  KeyEventResult homeHandler(FocusNode focus, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    
    if (event.logicalKey == LogicalKeyboardKey.pageUp) stickers.changePackUp();
    if (event.logicalKey == LogicalKeyboardKey.pageDown) stickers.changePackDown();
    if (event.logicalKey == LogicalKeyboardKey.home) stickers.changePackFirst();
    if (event.logicalKey == LogicalKeyboardKey.end) stickers.changePackLast();

    if ((event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter)
      && (stickers.selectedPackWidgets ?? []).isNotEmpty) {
        if ((stickers.filteredWidgets ?? []).isNotEmpty) {
          clipboard.copySticker(stickers.filteredWidgets![0].value.imageFile);
        } else {
          clipboard.copySticker(stickers.selectedPackWidgets![0].value.imageFile);
        }
      }
    
    return KeyEventResult.ignored;
  }
}