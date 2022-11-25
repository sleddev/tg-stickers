import 'dart:convert';
import 'dart:io';

class ConfigManager {

}

class ConfigData {
  List<StickerPackConfig> stickerPacks;

  ConfigData.fromJson(Map<String, dynamic> json, Directory wd)
    : stickerPacks = List<StickerPackConfig>.generate(
        (json['sticker_packs'] as List<dynamic>).length,
        (index) => StickerPackConfig.fromJson((json['sticker_packs'] as List<dynamic>)[index], wd)
      );
}

class StickerPackConfig {
  String name;
  String basePath;
  File coverFile;

  StickerPackConfig.fromJson(Map<String, dynamic> json, Directory wd)
    : coverFile = File(wd.path + json['cover_path']),
      basePath = json['base_path'],
      name = json['name'];
}