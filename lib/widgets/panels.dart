import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:tgstickers/widgets/titlebar.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: const Color(0xff3a3a3a),
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          height: 32,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: const Color(0xff9f9f9f),
              splashColor: Colors.transparent,
              hoverColor: const Color(0xff5b5b5b),
              onHighlightChanged: (value) {},
              onHover: (value) {},
              onTap: () {
              },
              child: const Icon(FluentSystemIcons.ic_fluent_add_regular, color: Color(0xfff2f2f2), size: 18),
            ),
          ),
        ),
      ]),  
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: const [
        SizedBox(height: 32,child: TitleBar(),),
        Expanded(child: TestArea()),
      ],
    );
  }
}

class TestArea extends StatefulWidget {
  const TestArea({super.key});

  @override
  State<TestArea> createState() => _TestAreaState();
}

class _TestAreaState extends State<TestArea> {
  final image = const NetworkImage('https://unsplash.com/photos/Zey2zWuxSwI/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY4NjE3MDI0&force=true');
  Directory? path;
  List<Sticker>? stickers;

  @override
  void initState() {
    getStickers();
    
    super.initState();
  }
  void getStickers() async {
    var res = await getApplicationDocumentsDirectory();
    var imgPath = Directory('${res.path}/TGStickers/stickerpacks/hiostickerpack');
    var imgList = <Sticker>[];
    imgPath.listSync().forEach((element) => imgList.add(Sticker(File(element.path))));



    setState(() {
      stickers = imgList;
    });
  }

  Widget gridView() {
    if (stickers == null) return const Text('...');
    return GridView.builder(itemBuilder: (context, index) => Container(padding: const EdgeInsets.all(2), child: stickers![index]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: stickers!.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return gridView();
  }
}

class Sticker extends StatelessWidget {
  const Sticker(this.imageFile, {
    Key? key
  }) : super(key: key);
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.file(File(imageFile.path), isAntiAlias: true, filterQuality: FilterQuality.medium),
      onTap: () async {
        var imageBytes = await imageFile.readAsBytes();
        var item = DataWriterItem(suggestedName: basename(imageFile.path));
        if (Platform.isWindows) {
          item.add(Formats.fileUri(imageFile.uri));
        } else {
          item.add(Formats.png(imageBytes));
        }
        await ClipboardWriter.instance.write([item]);
      },
    );
  }
}