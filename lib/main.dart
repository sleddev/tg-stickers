import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tgstickers/config_manager.dart';
import 'package:tgstickers/hoosk/hoosk.dart';
import 'package:tgstickers/widgets/toast.dart';
import 'package:window_manager/window_manager.dart';

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
  runApp(const MyApp());
}

class Controller {
  var stickerPacks = Writable<List<StickerPackConfig>>([]);
  var currentPack = Writable<List<Widget>>([]);
  var currentPackName = Writable<String>('');

  var stickerAreaOverlay = Writable<Widget>(Container());
  var toastOverlay = Writable<Widget>(Container());
  var toastIcon = Writable<IconData>(Icons.check);
  var toastColor = Writable<Color>(Colors.teal);

  Controller() {
    init();
  }

  void init() async {
    String path = await getPath();
    JSON configJson = jsonDecode(await File('$path/config.json').readAsString());
    ConfigData config = ConfigData.fromJson(configJson, Directory(path));

    stickerPacks.value = config.stickerPacks;
    changePack(stickerPacks.value.first.name);
  }

  Future<String> getPath() async {
    return '${(await getApplicationDocumentsDirectory()).path}\\TGStickers\\';
  }

  void changePack(String name) async {
    var res = await getPath();
    var packToLoad = stickerPacks.value.firstWhere((element) => element.name == name);
    var imgPath = Directory('$res${packToLoad.basePath}');
    var imgList = <Widget>[];
    imgPath.listSync().forEach((element) => imgList.add(sticker(File(element.path))));
    currentPackName.value = packToLoad.name;
    currentPack.value = imgList;
    stickerAreaOverlay.value = Container();
  }

  void infoToast(String message) {
    toastColor.value = Colors.teal;
    toastIcon.value = Icons.check;

    toastOverlay.value = Toast(message);
  }
  void hideToast() {
    toastOverlay.value = Container();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: const MyHomePage(),
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff333333),
        body: Flex(direction: Axis.horizontal, children: const [
          Expanded(flex: 1,child: LeftPanel(),),
          Expanded(flex: 6,child: RightPanel(),),
        ],)
      );
  }
}