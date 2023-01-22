import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tgstickers/providers/sticker_provider.dart';

class WindowProvider {
  final StickerProvider stickers;

  final ValueNotifier<bool> addOpen = ValueNotifier(false);
  final ValueNotifier<bool> addVisible = ValueNotifier(false);
  final Duration addTransition = const Duration(milliseconds: 100);

  WindowProvider({required this.stickers});

  void showAdd() {
    addVisible.value = true;
    addOpen.value = true;
  }

  void hideAdd() {
    addOpen.value = false;
    Timer(addTransition, () => addVisible.value = false);
    stickers.loadPacks();
  }
}