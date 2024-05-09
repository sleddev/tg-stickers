import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/config_model.dart';

class ConfigProvider extends ChangeNotifier {
  Future<String> getPath() async {
    return '${(await getApplicationDocumentsDirectory()).path}/TGStickers/';
  }

  Future<ConfigData> getConfig() async {
    String path = await getPath();

    File configFile = File('$path/config.json');
    String configString;
    try {
      configString = await configFile.readAsString();
    } on FileSystemException {
      configString = """
{
  "token": "",
  "always_on_top": true,
  "sticker_packs": []
}
""";
    }

    Map<String, dynamic> configJson =
        jsonDecode(configString.isEmpty ? '{}' : configString);
    ConfigData config = ConfigData.fromJson(configJson, Directory(path));

    return config;
  }

  /// Updates the `config.json` file.
  ///
  /// If an `update` function in provided, the other arguments aren't used
  Future<void> updateConfig({
    Future<ConfigData> Function(ConfigData value)? updater,
    String? token,
    int? copySize,
    bool? showSearchBar,
    List<StickerPackConfig>? stickerPacks,
  }) async {
    File configFile = File('${await getPath()}/config.json');
    var config = await getConfig();
    ConfigData updated;

    if (updater == null) {
      updated = config;

      if (token != null) updated.token = token;
      if (copySize != null) updated.copySize = copySize;
      if (showSearchBar != null) updated.showSearchBar = showSearchBar;
      if (stickerPacks != null) updated.stickerPacks = stickerPacks;
    } else {
      updated = await updater(config);
    }

    var encoder = const JsonEncoder.withIndent('  ');
    String prettyJson = encoder.convert(updated.toJson());
    await configFile.writeAsString(prettyJson);
  }
}
