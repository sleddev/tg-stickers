import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

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
    lastPos = await windowManager.getPosition();
    await windowManager.hide();
    settingsOpen.value = true;
    await windowManager.setSize(const Size(640, 480));
    await windowManager.setAlignment(Alignment.center);
    await windowManager.show();
  }

  void hideSettings() async {
    await windowManager.hide();
    settingsOpen.value = false;
    await windowManager.setSize(const Size(440, 380));
    await windowManager.setAlignment(Alignment.topLeft);
    if (lastPos != null) await windowManager.setPosition(lastPos!);
    await windowManager.show();
  }
}