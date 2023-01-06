import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tgstickers/config_manager.dart';
import 'package:tgstickers/hoosk/hoosk.dart';
import 'package:tgstickers/telegram/downloader.dart';
import 'package:tgstickers/widgets/settings.dart';
import 'package:tgstickers/widgets/toast.dart';
import 'package:window_manager/window_manager.dart';

import 'widgets/addoverlay.dart';
import 'widgets/panels.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // window manager
  windowManager.ensureInitialized();


  windowManager.waitUntilReadyToShow().then((_) async {
    // await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setAsFrameless();
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setTitle('TG Stickers');
    await windowManager.setSize(const Size(440, 380));
    await windowManager.setResizable(false);
    if (Platform.isWindows) await windowManager.setHasShadow(true);
    windowManager.show();
  });

  GetIt.I.registerSingleton<Controller>(Controller());

  runApp(const MyApp());
}

class Controller {
  var stickerPacks = Writable<List<StickerPackConfig>>([]);
  var currentPack = Writable<List<Widget>>([]);
  var currentPackName = Writable<String>('');

  var stickerAreaOverlay = Writable<Widget>(Container());
  var addOverlay = Writable<Widget>(const AddOverlay());
  var toastOverlay = Writable<Widget>(const Toast('Sticker copied'));
  var toastStatus = Writable<bool>(false);
  var toastIcon = Writable<IconData>(FluentSystemIcons.ic_fluent_copy_regular);
  var toastColor = Writable<Color>(Colors.teal);

  var settingsOpen = Writable<bool>(false);
  var addVisible = Writable<bool>(false);

  var lastPosition = const Offset(0, 0);
  var lastSize = const Size(440, 380);

  Controller() {
    init();
  }

  void init() async {
    stickerPacks.value = (await getConfig()).stickerPacks;
    changePack(stickerPacks.value.first.name);
    //infoToast('Sticker copied');
  }
  Future<ConfigData> getConfig() async {
    String path = await getPath();

    File configFile = File('$path/config.json');
    JSON configJson = jsonDecode(await configFile.readAsString());
    ConfigData config = ConfigData.fromJson(configJson, Directory(path));

    return config;
  }

  Future<String> getPath() async {
    return '${(await getApplicationDocumentsDirectory()).path}/TGStickers/';
  }

  void changePack(String name) async {
    var res = await getPath();
    var packToLoad = stickerPacks.value.firstWhere((element) => element.name == name);
    var imgPath = Directory('$res${packToLoad.basePath}');
    var imgList = <Widget>[];
    var fileList = imgPath.listSync();
    fileList.removeWhere((element) => element.path.contains('cover.png'));
    for (var element in fileList) {
      imgList.add(sticker(File(element.path)));
    }
    currentPackName.value = packToLoad.name;
    currentPack.value = imgList;
    stickerAreaOverlay.value = Container();
  }

  //TODO: fix UI rebuild not triggering
  //TODO: duplicate detection
  void addPack(String name, String basePath, String coverPath) async {
    if (!stickerPacks.value.every((element) => element.name != name)) return;
    File configFile = File('${await getPath()}/config.json');
    ConfigData config = await getConfig();
    config.stickerPacks.add(StickerPackConfig.fromJson({
      'name': name,
      'base_path': basePath,
      'cover_path': coverPath,
    }, Directory(await getPath())));

    var encoder = const JsonEncoder.withIndent('  ');
    String prettyJson = encoder.convert(config.toJson());
    configFile.writeAsString(prettyJson);

    stickerPacks.value = config.stickerPacks;
  }

  void infoToast(String message) {
    toastColor.value = Colors.teal;
    toastIcon.value = FluentSystemIcons.ic_fluent_copy_regular;

    toastStatus.value = true;
  }
  void hideToast() {
    toastStatus.value = false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final c = getIt<Controller>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: hListen(c.settingsOpen, (value) => !value ?
        const HomePage() : const SettingsPage()
      ),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(border: Border(
            bottom: BorderSide(color: Color(0xff535353), width: 2),
            left: BorderSide(color: Color(0xff535353), width: 1),
            right: BorderSide(color: Color(0xff535353), width: 1),
            top: BorderSide(color: Color(0xff535353), width: 1),
            ),
            color: Color(0xff333333),
          ),
          child: child!,
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = getIt<Controller>();

    return Scaffold(
        backgroundColor: const Color(0xff333333),
        body: Stack(
          children: [
            Flex(direction: Axis.horizontal, children: const [
              Expanded(flex: 1,child: LeftPanel(),),
              Expanded(flex: 6,child: RightPanel(),),
            ],),
            hListen(c.addOverlay, (value) => value,)
          ],
        )
      );
  }
}