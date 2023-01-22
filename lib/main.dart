import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tgstickers/app.dart';
import 'package:tgstickers/providers/config_provider.dart';
import 'package:tgstickers/providers/sticker_provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setAsFrameless();
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setTitle('TG Stickers');
    await windowManager.setSize(const Size(440, 380));
    await windowManager.setResizable(false);
    if (Platform.isWindows) await windowManager.setHasShadow(true);
    windowManager.show();
  });

  Startup startup = Startup();
  await startup.start();

  runApp(App(stickers: startup.stickers, configProvider: startup.configProvider, ));
}

class Startup {
  late StickerProvider stickers;
  late ConfigProvider configProvider;

  Future<void> start() async {
    configProvider = ConfigProvider();
    stickers = StickerProvider(configProvider);
  }
}