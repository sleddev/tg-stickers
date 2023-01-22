import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tgstickers/models/config_model.dart';
import 'package:tgstickers/providers/config_provider.dart';

import '../pages/home/widgets/small_sticker.dart';

class StickerProvider extends ChangeNotifier {
  List<StickerPackConfig> stickerPacks = [];
  final ConfigProvider configProvider;

  StickerPackConfig? selectedPack;
  List<SmallSticker>? selectedPackWidgets;

  File? bigSticker;
  ValueNotifier<bool> bigStickerVisible = ValueNotifier(false);
  Duration bigStickerTransition = const Duration(milliseconds: 65);

  StickerProvider(this.configProvider) {
    init();
  }

  Future<void> init() async {
    var path = await configProvider.getPath();
    await Directory('$path/stickerpacks').create(recursive: true);
    await File('$path/config.json').create(recursive: true);

    await loadPacks();
    if (stickerPacks.isNotEmpty) await changePack(index: 0);
  }

  Future<void> loadPacks({bool notify = true}) async {
    stickerPacks = (await configProvider.getConfig()).stickerPacks;

    if (notify) notifyListeners();
  }

  Future<void> changePack({String? id, int? index }) async {
    if (id != null) selectedPack = stickerPacks.firstWhere((element) => element.id == id);
    if (index != null) selectedPack = stickerPacks[index];

    loadCurrentPack();
    notifyListeners();
  }

  Future<void> loadCurrentPack() async {
    if (selectedPack == null) return;

    var path = await configProvider.getPath();
    var imgPath = Directory(selectedPack!.basePath).isAbsolute ? Directory(selectedPack!.basePath) : Directory('$path${selectedPack!.basePath}');
    var fileList = imgPath.listSync();
    fileList.removeWhere((element) => element.path.contains('cover.png'));

    var stickerList = <SmallSticker>[];
    for (var element in fileList) {
      stickerList.add(SmallSticker(imageFile: File(element.path)));
    }

    selectedPackWidgets = stickerList;
    notifyListeners();
  }

  void setBigSticker(File? imageFile) {
    bigSticker = imageFile;
    notifyListeners();
  }

  void showBigSticker(File imageFile) {
    setBigSticker(imageFile);
    bigStickerVisible.value = true;
    notifyListeners();
  }

  void hideBigSticker() {
    bigStickerVisible.value = false;
    Timer(bigStickerTransition, () {
      bigSticker = null;
      notifyListeners();
    });
  }

  Future<void> addPack({required String name, required String id, required String basePath, required String coverPath}) async {
    if (!stickerPacks.every((element) => element.name != name)) return;
    configProvider.updateConfig(
      updater: (value) async {
        value.stickerPacks.add(StickerPackConfig.fromJson({
          'name': name,
          'id': id,
          'base_path': basePath,
          'cover_path': coverPath,
        }, Directory(await configProvider.getPath())));
        return value;
      },
    );
    loadPacks();
    notifyListeners();
  }
}