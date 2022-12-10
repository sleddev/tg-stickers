import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tgstickers/hoosk/hoosk.dart';
import 'package:http/http.dart' as http;

import 'converter.dart';


//TODO: caching
class StickerDownloader {
  StickerDownloader(this.token)
    : api = 'https://api.telegram.org/bot$token/';

  String token;
  String api;

  // TODO: verify token in constructor

  Future<JSON> doApiReq(String endpoint, Map<String, String> params) async {
    var scheme = api.split('://')[0];
    var apiSegment = api.split('://')[1].split('/');
    var host = apiSegment[0];
    var path = '${apiSegment.getRange(1, apiSegment.length - 1).join('/')}/$endpoint';
    var url = Uri(queryParameters: params, scheme: scheme, host: host, path: path);
    var response = await http.get(url);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPack(String packName) async {
    print('getting pack info');
    var params = {'name': packName};
    var res = await doApiReq('getStickerSet', params);
    print(res);
    var stickers = res['result']['stickers'];
    var files = [];

    //TODO: multithreading
    for (var i in stickers) {
      i = await getSticker(i);
      files.add(i);
    }

    var pack = {
      'name': res['result']['name'],
      'title': res['result']['title'],
      'files': files,
      'cover_id': res['result']['thumb'] != null ? res['result']['thumb']['file_id'] : ''
    };
    return pack;
  }

  getSticker(fileData) async {
    var info = await doApiReq('getFile', {'file_id': fileData['file_id']});
    String filePath = info['result']['file_path'];
    var file = StickerData(
      filePath.split('/')[filePath.split('/').length - 1],
      'https://api.telegram.org/file/bot$token/$filePath',
      fileData['emoji'],
      filePath.split('.')[filePath.split('.').length - 1]
    );
    return file;
  }

  //TODO: check downoaded files
  downloadPack(Map<String, dynamic> pack, String directory) async {
    print('downloading pack');
    var saveDir = await Directory(directory).create(recursive: true);
    var downloads = [];

    //TODO: multithreading
    (pack['files'] as List<dynamic>).asMap().forEach((index, sticker) async {
      //TODO: convert emojis to text
      await downloadSticker('${saveDir.path}/webp/${(index + 1).toString().padLeft(4, '0')}-${sticker.emoji}.${sticker.fileType}', sticker.link);
    });
    if (pack['cover_id'] != '') {
      String coverPath = (await doApiReq('getFile', {'file_id': pack['cover_id']}))['result']['file_path'];
      var cover = StickerData('cover', 'https://api.telegram.org/file/bot$token/$coverPath', '', coverPath.split('.')[coverPath.split('.').length - 1]);
      downloadSticker('${saveDir.path}/webp/cover.${cover.fileType}', cover.link);

    }

    print('finished saving');
    return downloads;
  }

  downloadSticker(String path, String link) async {
    print(path);
    await (await File('$path').create(recursive: true)).writeAsBytes((await http.get(Uri.parse(link))).bodyBytes);
  }

  Future<void> convertPack(String path, Function callback) async {
    print('converting pack');
    var saveDir = await Directory(path).create(recursive: true);

    //TODO: convert animated stickers
    var errored = false;
    try {
      var convertedWebp = await convertWebp(saveDir.path);
    } catch (e) {
      errored = true;
    }
    if (errored) {
      Timer(Duration(milliseconds: 10), () async {
        await convertPack(path, callback);
      },);
    } else {
        Directory('${saveDir.path}/webp').delete(recursive: true);
        callback();
    }
  }

}

class StickerData {
  StickerData(this.name, this.link, this.emoji, this.fileType);

  String name;
  String link;
  String emoji;
  String fileType = 'webp';
}