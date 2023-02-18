import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'config_provider.dart';
import '../models/config_model.dart';
import '../pages/home/widgets/small_sticker.dart';

class StickerProvider extends ChangeNotifier {
  List<StickerPackConfig> stickerPacks = [];
  final ConfigProvider configProvider;

  StickerPackConfig? selectedPack;
  List<MapEntry<String, SmallSticker>>? selectedPackWidgets;
  List<MapEntry<String, SmallSticker>>? filteredWidgets;

  File? bigSticker;
  String? bigStickerEmoji;
  ValueNotifier<bool> bigStickerVisible = ValueNotifier(false);
  Duration bigStickerTransition = const Duration(milliseconds: 65);

  StickerPackConfig? menuPack;
  ValueNotifier<bool> packMenuVisible = ValueNotifier(false);
  ValueNotifier<bool> packMenuOpen = ValueNotifier(false);
  ValueNotifier<bool> packMenuDelete = ValueNotifier(false);
  ValueNotifier<String> packMenuStatus = ValueNotifier('menu');
  Duration packMenuTransition = const Duration(milliseconds: 65);

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
    hidePackMenu();

    await loadCurrentPack();
    filteredWidgets = [];
    notifyListeners();
  }

  Future<void> loadCurrentPack() async {
    if (selectedPack == null) return;

    var path = await configProvider.getPath();
    var imgPath = Directory(selectedPack!.basePath).isAbsolute ? Directory(selectedPack!.basePath) : Directory('$path${selectedPack!.basePath}');
    if (!await imgPath.exists()) {
      selectedPackWidgets = [];
      return;
    }
    var fileList = imgPath.listSync();
    fileList.removeWhere((element) => element.path.contains('cover.png'));

    var supportedTypes = ['.jpg', '.jpeg', '.jfif', '.png', '.webp', '.gif', '.bmp'];

    var entryList = <MapEntry<String, SmallSticker>>[];
    for (var element in fileList) {
      if ((await element.stat()).type != FileSystemEntityType.file) continue;
      if (!supportedTypes.contains(extension(element.path).toLowerCase())) continue; //{

      String keywords = basename(element.path).split('-').last.replaceAll('_', ' ');
      String emoji = '';
      try {
        emoji = basename(element.path).split('-').first.characters.last;
      } catch (e) {
        emoji = '';
      }
      entryList.add(MapEntry(emoji + keywords, SmallSticker(imageFile: File(element.path), emoji: emoji)));
    }

    selectedPackWidgets = entryList;
    notifyListeners();
  }

  Future<void> filterCurrentPack(String query) async {
    if (query.isEmpty) filteredWidgets = selectedPackWidgets;
    filteredWidgets = selectedPackWidgets?.where((element) {
      if (element.key.toLowerCase().contains(query.toLowerCase())) return true;
      return false;
    }).toList();
    notifyListeners();
  }

  void setBigSticker(File? imageFile, String? emoji) {
    bigStickerEmoji = emoji;
    bigSticker = imageFile;
    notifyListeners();
  }

  void showBigSticker(File imageFile, String emoji) {
    setBigSticker(imageFile, emoji);
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

  void showPackMenu(int index) {
    menuPack = stickerPacks[index];
    notifyListeners();
    packMenuVisible.value = true;
    packMenuOpen.value = true;
  }

  void hidePackMenu() {
    packMenuOpen.value = false;
    Timer(packMenuTransition, () {
      packMenuVisible.value = false;
      packMenuStatus.value = 'menu';
      packMenuDelete.value = false;
    });
  }

  void setPackMenuStatus(String status) {
    packMenuStatus.value = status;
  }

  Future<void> removePack(bool delete) async {
    await configProvider.updateConfig(
      updater: (value) async {
        if (menuPack == null) return value;
        value.stickerPacks.removeWhere((element) => element.id == menuPack!.id);
        return value;
      },
    );
    if (delete) await Directory(await configProvider.getPath() + menuPack!.basePath).delete(recursive: true);

    selectedPack = null;

    loadPacks();
    notifyListeners();

    hidePackMenu();
  }

  Future<void> moveUp() async {
    if (menuPack == null) return;

    await configProvider.updateConfig(
      updater: (value) async {
        var index = value.stickerPacks.indexWhere((element) => element.id == menuPack!.id);
        if (index == 0 || value.stickerPacks.length == 1) return value;
        var next = value.stickerPacks[index - 1];
        value.stickerPacks.insert(index + 1, next);
        value.stickerPacks.removeAt(index - 1);

        return value;
      },
    );

    await loadPacks();
    notifyListeners();
  }
  Future<void> moveDown() async {
    if (menuPack == null) return;

    await configProvider.updateConfig(
      updater: (value) async {
        var index = value.stickerPacks.indexWhere((element) => element.id == menuPack!.id);
        if (index == value.stickerPacks.length - 1 || value.stickerPacks.length == 1) return value;
        var next = value.stickerPacks[index + 1];
        value.stickerPacks.removeAt(index + 1);
        value.stickerPacks.insert(index, next);

        return value;
      },
    );

    await loadPacks();
    notifyListeners();
  }
}