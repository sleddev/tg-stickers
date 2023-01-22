import 'dart:io';

class ConfigData {
  String token;
  List<StickerPackConfig> stickerPacks;

  ConfigData(this.token, this.stickerPacks);

  ConfigData.fromJson(Map<String, dynamic> json, Directory wd)
    : token = json['token'] ?? '',
      stickerPacks = List<StickerPackConfig>.generate(
        ((json['sticker_packs'] ?? []) as List<dynamic>).length,
        (index) => StickerPackConfig.fromJson(((json['sticker_packs'] ?? []) as List<dynamic>)[index], wd));

  Map<String, dynamic> toJson() => {
    'token': token,
    'sticker_packs': List.generate(stickerPacks.length, (index) => stickerPacks[index].toJson())
  };
}

class StickerPackConfig {
  String name;
  String id;
  String basePath;
  File coverFile;
  String coverPath;

  StickerPackConfig.fromJson(Map<String, dynamic> json, Directory wd)
    : coverFile = File(wd.path + json['cover_path']),
      coverPath = json['cover_path'],
      basePath = json['base_path'],
      name = json['name'],
      id = json['id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'cover_path': coverPath,
    'base_path': basePath,
  };
}