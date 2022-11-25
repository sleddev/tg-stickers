import 'dart:io';

import 'package:path/path.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:tgstickers/hoosk/hoosk.dart';
import 'package:tgstickers/main.dart';
import 'package:tgstickers/utils.dart';
import 'package:tgstickers/widgets/titlebar.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final c = getIt<Controller>();

    Widget packsWidget() {
      return Column(children:
        [...hEach(c.stickerPacks.value, 
          (item, i) => Container(
            padding: const EdgeInsets.all(4),
            child: 
              GestureDetector(
                onTap: () => c.changePack(item.name),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: hHover(const Color(0x33ffffff), Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.file(item.coverFile, filterQuality: FilterQuality.medium, isAntiAlias: true),
                  )),
                ),
              )
          )
        ),
        ]
      );
    }

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
        hListen(c.stickerPacks, (value) => packsWidget())
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
  final c = getIt<Controller>();
  final image = const NetworkImage('https://unsplash.com/photos/Zey2zWuxSwI/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjY4NjE3MDI0&force=true');
  Directory? path;
  List<Sticker>? stickers;

  @override
  void initState() {
    
    super.initState();
  }

  Widget packHeader() {
    return hListen(c.currentPackName ,
    (name) => SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 28,
        child: FittedBox(
          alignment: Alignment.topLeft,
          fit: BoxFit.fitHeight,
          child: Text(
            name.toUpperCase(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xffbbbbbb),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ));
  }

  Widget packContent() {
    return hListen(c.currentPack,
      (value) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(padding: const EdgeInsets.all(2), child: value[index]),
            childCount: value.length
          ),
        ),
      ),
    );
  }

  Widget gridView() {
    var scrollController = AdjustableScrollController(20);

    return RawScrollbar(
      controller: scrollController,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          packHeader(),
          packContent(),
        ],
      ),
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
    final c = getIt<Controller>();

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