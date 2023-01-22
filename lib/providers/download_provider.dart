import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tgstickers/logic/telegram/converter.dart';
import 'package:tgstickers/logic/telegram/downloader.dart';
import 'package:tgstickers/logic/telegram/telegram_api.dart';
import 'package:tgstickers/providers/config_provider.dart';

import 'sticker_provider.dart';

class DownloadProvider extends ChangeNotifier {
  final ConfigProvider config;
  final StickerProvider stickers;

  String? status;
  String? error;

  DownloadProvider({required this.config, required this.stickers});

  Future<void> saveToken(String token) async {
    await config.updateConfig(token: token);
  }

  void showError(String message) {
    error = message;
    status = 'error';
    notifyListeners();
  }

  Future<void> downloadPack(String link, String token) async {
    try {
      status = 'info';
      notifyListeners();

      var api = TelegramAPI(token: token);
      await api.checkToken();
      config.updateConfig(token: token);

      var name = link.split('://').last.split('/').last;

      var dowmloader = Downloader(api: api);
      var pack = await dowmloader.getPack(name);

      status = 'download';
      notifyListeners();
      await dowmloader.downloadPack(pack, '${await config.getPath()}stickerpacks/$name');

      status = 'convert';
      notifyListeners();
      var converter = Converter(api: api);
      Timer(const Duration(milliseconds: 1000), () async {
        await converter.convertPack('${await config.getPath()}stickerpacks/$name');

        var coverExists = await File('${await config.getPath()}stickerpacks/$name/cover.png').exists();
        var coverPath = coverExists ? 'stickerpacks/$name/cover.png'
          : 'stickerpacks/$name/${basename(Directory('${await config.getPath()}stickerpacks/$name').listSync().first.path)}';
        stickers.addPack(
          name: pack['title'],
          id: name,
          basePath: 'stickerpacks/$name',
          coverPath: coverPath
        );

        status = 'done';
        notifyListeners();

      });


    } on String catch (e) {
      showError(e);
    }
  }
}