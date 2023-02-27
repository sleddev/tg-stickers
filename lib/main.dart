import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'providers/config_provider.dart';
import 'providers/sticker_provider.dart';

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

    await windowManager.setAlwaysOnTop((await configProvider.getConfig()).alwaysOnTop);

    startTray();
  }

  Future<bool> startTray() async {
    try {
      await Process.start('tgs-tray.exe', []);
      return true;
    } catch (e) {
      return false;
    }
  }
}