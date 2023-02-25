import 'dart:async';

import 'package:flutter/material.dart';

import 'sticker_provider.dart';

class WindowProvider extends ChangeNotifier {
  final StickerProvider stickers;

  Offset? lastPos;
  final ValueNotifier<bool> settingsOpen = ValueNotifier(false);

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

  void showSettings() async {
    settingsOpen.value = true;
  }

  void hideSettings() async {
    settingsOpen.value = false;
  }
}