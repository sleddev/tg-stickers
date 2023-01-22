import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TelegramAPI {
  final String token;
  http.Client? client;

  TelegramAPI({required this.token});

  Future<Map<String, dynamic>> doAPIReq(String endpoint, Map<String, String> params) async {
    var url = Uri(scheme: 'https', host: 'api.telegram.org', path: 'bot$token/$endpoint', queryParameters: params);
    String? response;
    try {
      response = client != null ? await client!.read(url) : await http.read(url);
    } on http.ClientException catch(e) {
      if(kDebugMode) log(e.message.split(':').last.trim());
    }
    return jsonDecode(response ?? '{"ok": false}') as Map<String, dynamic>;
  } 

  Future<void> checkToken() async {
    var res = await doAPIReq('getMe', {});
    if (!res['ok']) throw "Invalid token";
  }

  Future<Map<String, dynamic>> getBasePack(String name) async {
    var params = {'name': name};
    var res = await doAPIReq('getStickerSet', params);
    if (!res['ok']) throw "Pack doesn't exist";
    return res['result'];
  }

  Future<Map<String, dynamic>> getStickerInfo(Map<String, dynamic> stickerData) async {
    var res = await doAPIReq('getFile', {'file_id': stickerData['file_id']});
    if (!res['ok']) throw "Sticker doesn't exist";
    res = res['result'];

    return {
      'link': 'https://api.telegram.org/file/bot$token/${res["file_path"]}',
      'emoji': stickerData['emoji'],
      'file_type': (res['file_path'] as String).split('.').last
    };
  }

  void initializeClient() {
    client = http.Client();
  }
  void destroyClient() {
    client?.close();
    client = null;
  }

}