import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tgstickers/config_manager.dart';
import 'package:tgstickers/hoosk/hoosk.dart';
import 'package:window_manager/window_manager.dart';

import 'widgets/panels.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // window manager
  windowManager.ensureInitialized();
  // acrylic
  Window.initialize();
  Window.setEffect(effect: WindowEffect.transparent);


  windowManager.waitUntilReadyToShow().then((_) async {
    // await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setAsFrameless();
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
  var currentPack = Writable<List<Sticker>>([]);
  var currentPackName = Writable<String>('');

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
    var imgList = <Sticker>[];
    imgPath.listSync().forEach((element) => imgList.add(Sticker(File(element.path))));
    currentPackName.value = packToLoad.name;
    currentPack.value = imgList;
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: child!
          ),
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
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Flex(direction: Axis.horizontal, children: const [
            Expanded(flex: 1,child: LeftPanel(),),
            Expanded(flex: 6,child: RightPanel(),),
          ],),
        )
      );
  }
}