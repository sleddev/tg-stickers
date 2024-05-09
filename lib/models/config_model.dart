import 'dart:io';

class ConfigData {
  String token;
  bool alwaysOnTop;
  int copySize;
  bool showSearchBar;
  List<StickerPackConfig> stickerPacks;

  ConfigData(this.token, this.alwaysOnTop, this.copySize, this.showSearchBar, this.stickerPacks,);

  ConfigData.fromJson(Map<String, dynamic> json, Directory wd)
    : token = json['token'] ?? '',
      alwaysOnTop = json['always_on_top'] is bool ? json['always_on_top'] ?? true : true,
      copySize = json['copy_size'] is int ? json['copy_size'] ?? 512 : 512,
      showSearchBar = json['show_search_bar'] is bool ? json['show_search_bar'] ?? true : true,
      stickerPacks = List<StickerPackConfig>.generate(
        ((json['sticker_packs'] ?? []) as List<dynamic>).length,
        (index) => StickerPackConfig.fromJson(((json['sticker_packs'] ?? []) as List<dynamic>)[index], wd));

  Map<String, dynamic> toJson() => {
    'token': token,
    'always_on_top': alwaysOnTop,
    'copy_size': copySize,
    'show_search_bar': showSearchBar,
    'sticker_packs': List.generate(stickerPacks.length, (index) => stickerPacks[index].toJson()),
  };
}

class StickerPackConfig {
  String name;
  String id;
  String basePath;
  File coverFile;
  String coverPath;

  StickerPackConfig.fromJson(Map<String, dynamic> json, Directory wd)
    : coverFile = File(json['cover_path']).isAbsolute ? File(json['cover_path']) : File(wd.path + json['cover_path']),
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