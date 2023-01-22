import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart';

import 'telegram_api.dart';

class Converter {
  final TelegramAPI api;

  Converter({required this.api});

  Future<void> convertPack(String path) async {
    var webpDir = await Directory('$path/webp').create(recursive: true);
    var files = webpDir.listSync();
    if (files.isEmpty) throw 'WebP folder empty';

    for (var imageFile in files) {
      var bytes = await File(imageFile.path).readAsBytes();
      Image? webpImage = decodeWebP(bytes);
      var pngBytes = encodePng(webpImage!);
      var destFile = await File('$path/${basename(imageFile.path).split('.')[0]}.png').create();
      await destFile.writeAsBytes(pngBytes);
    }

    await webpDir.delete(recursive: true);

  }
}