import 'dart:async';
import 'dart:io';

import 'package:blur/blur.dart';
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
    final sc = ScrollController();

    return Container(color: const Color(0xff3a3a3a),
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          height: 32,
          child: GestureDetector(
            onTap: () {
              //c.addOverlay.value = AddOverlay();
                c.addVisible.value = true;
              // Timer(Duration(milliseconds: 5), () {
              // },);
            },
            child: hHover(const Color(0x33ffffff), const Icon(FluentSystemIcons.ic_fluent_add_regular, color: Color(0xfff2f2f2), size: 18))
          ),
        ),
        Expanded(
          child: hListen(c.stickerPacks, (value) => RawScrollbar(
            controller: sc,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                controller: sc,
                itemCount: value.length,
                itemBuilder: (context, index) => AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: () => c.changePack(value[index].name),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: hHover(const Color(0x33ffffff), Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.file(value[index].coverFile, filterQuality: FilterQuality.medium, isAntiAlias: true),
                      )),
                    ),
                    ),
                  ),
                ),
              ),
            ),
          )),
        )
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
        Expanded(child: StickerArea()),
      ],
    );
  }
}

class StickerArea extends StatelessWidget {
  const StickerArea({super.key});

  @override
  Widget build(BuildContext context) {
    var c = getIt<Controller>();

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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 2, crossAxisSpacing: 2),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ClipRRect(borderRadius: BorderRadius.circular(8), child: hHover(const Color(0x33ffffff), Container(padding: const EdgeInsets.all(2), child: value[index]))),
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
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              packHeader(),
              packContent(),
            ],
          ),
        ),
      );
    }

    return Stack(children: [
        gridView(),
        hListen(c.stickerAreaOverlay, (value) => SizedBox(width: double.infinity, height: double.infinity, child: value)),
        hListen(c.toastOverlay, (value) => value),
      ]
    );
  }
}

Widget sticker(File imageFile) {
  var c = getIt<Controller>();

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
      c.infoToast('Sticker copied');
      Timer(const Duration(milliseconds: 1300), (() => c.hideToast()));
    },
    onSecondaryTap: () => c.stickerAreaOverlay.value = bigSticker(imageFile),
  );
}

Widget bigSticker(File imageFile) {
  var c = getIt<Controller>();
  return GestureDetector(
    onTap: () => c.stickerAreaOverlay.value = Container(),
    onSecondaryTap: () => c.stickerAreaOverlay.value = Container(),
    child: Blur(
      blur: 10,
      overlay: Container(width: double.infinity, height: double.infinity, color: const Color(0x77000000) ,padding: const EdgeInsets.all(65), 
        child: TransparentImageButton.assets(
          imageFile,
          onTapInside: () async {
            var imageBytes = await imageFile.readAsBytes();
            var item = DataWriterItem(suggestedName: basename(imageFile.path));
            if (Platform.isWindows) {
              item.add(Formats.fileUri(imageFile.uri));
            } else {
              item.add(Formats.png(imageBytes));
            }
            await ClipboardWriter.instance.write([item]);
            c.infoToast('Sticker copied');
            Timer(const Duration(milliseconds: 1300), (() => c.hideToast()));
          },
          onTapOutside: () => c.stickerAreaOverlay.value = Container(),
          
        )
      ),
      child: Container(),
    )
    );
}