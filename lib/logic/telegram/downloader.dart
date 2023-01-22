import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:tgstickers/logic/telegram/telegram_api.dart';

class Downloader {
  final TelegramAPI api;
  final bool speedy; //freezy!

  Downloader({required this.api, this.speedy = false});

  //TODO: check if downloaded
  Future<Map<String, dynamic>> getPack(String name) async {
    var baseInfo = await api.getBasePack(name);

    //TODO: multithreading
    List<Map<String, dynamic>> files = [];
    api.initializeClient();
    for (Map<String, dynamic> sticker in baseInfo['stickers']) {
      if (speedy) {
        compute(api.getStickerInfo, sticker).then((value) => files.add(value));
      } else {
        sticker = await api.getStickerInfo(sticker);
        files.add(sticker);
      }
    }
    if (speedy) {
      while (baseInfo['stickers'].length != files.length) {
        sleep(const Duration(milliseconds: 100));
      }
    }
    api.destroyClient();

    String? coverID;
    if (baseInfo['thumb'] != null) coverID = baseInfo['thumb']['file_id'];
    Map<String, dynamic>? cover;
    if (coverID != null) {
      var coverInfo = await api.doAPIReq('getFile', {'file_id': coverID});
      if (!coverInfo['ok']) throw 'Invalid cover';
      coverInfo = coverInfo['result'];
      cover = {
        'link': 'https://api.telegram.org/file/bot${api.token}/${coverInfo["file_path"]}',
        'emoji': '',
        'file_type': (coverInfo['file_path'] as String).split('.').last
      };
    }

    Map<String, dynamic> pack = {
      'name': baseInfo['name'],
      'title': baseInfo['title'],
      'files': files,
      'cover': cover
    };
    return pack;
  }

  Future<void> downloadPack(Map<String, dynamic> pack, String path) async {
    var saveDir = await Directory(path).create(recursive: true);

    if (pack['cover'] != null) await downloadSticker(pack['cover']['link'], '${saveDir.path}/webp/cover.${pack['cover']['file_type']}');

    List<Map<String, dynamic>> files = pack['files'];
    files.asMap().forEach((i, sticker) async {
      await downloadSticker(sticker['link'], '${saveDir.path}/webp/${(i + 1).toString().padLeft(4, "0")}-${sticker["emoji"]}.${sticker["file_type"]}');
    });
  }

  Future<void> downloadSticker(String link, String path) async {
    var file = await File(path).create(recursive: true);
    await file.writeAsBytes((await http.get(Uri.parse(link))).bodyBytes);
  }
}