import 'dart:io';

import 'package:image/image.dart';
import 'package:path/path.dart';

convertWebp(String path) async {
  print('starting conversion');
  var saveDir = await Directory(path).create(recursive: true);
  var files = Directory('$path/webp').listSync();
  if (files.length == 0) {
    throw Exception('WebP folder empty!');
  }

  //TODO: multithreading
  for (var _imageFile in files) {
    var imageFile = File(_imageFile.path);
    var bytes = await File(imageFile.path).readAsBytes();
    Image? image = decodeWebP(bytes);
    print(image!.height);
    var png = encodePng(image);
    var saveFile = await File('$path/${basename(imageFile.path).split('.')[0]}.png').create();
    var asd = await saveFile.writeAsBytes(png);
  }
}