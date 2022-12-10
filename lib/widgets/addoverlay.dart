import 'dart:async';
import 'dart:io';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:window_manager/window_manager.dart';

import '../hoosk/hoosk.dart';
import '../main.dart';
import '../telegram/downloader.dart';

class DownloadController {
  var statusText = Writable<String>('');
  var stickerLink = '';
}

class AddOverlay extends StatelessWidget {
  const AddOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    GetIt.I.allowReassignment = true;
    GetIt.I.registerSingleton(DownloadController());
    final c = getIt<Controller>();

    return hFade(c.addVisible, 100, 
      Container(
        decoration: const BoxDecoration(color: Color(0xff333333)),
        child: Flex(
          direction: Axis.horizontal,
          children: const [
            Expanded(flex: 1, child: LeftSide()),
            Expanded(flex: 6, child: RightSide())
          ],
        ),
      )
    );
  }
}

class LeftSide extends StatelessWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    final c = getIt<Controller>();

    return Container(
      color: const Color(0xff3a3a3a),
      child: Column(
        children: [
          GestureDetector(
          onTap: () => c.addVisible.value = false, 
          child: hHover(const Color(0x33ffffff), const SizedBox(
            height: 32,
            width: double.infinity,
            child: Icon(FluentSystemIcons.ic_fluent_arrow_left_regular, color: Color(0xfff2f2f2), size: 18,),
          ))),
          const SizedBox(height: 16,),
          Container(color: const Color(0xff333333), height: 48, width: double.infinity, child: const Icon(FluentSystemIcons.ic_fluent_arrow_download_regular, color: Color(0xfff2f2f2), size: 18,),)
        ],
      ),
    );
  }
}

class RightSide extends StatelessWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 32, child: _TitleBar()),
        Expanded(child: DownloadPanel())
      ],
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(
              child: DragToMoveArea(child: _DragBar())
            ),
          ]
        ),
      )
    ]);
  }
}

class _DragBar extends StatelessWidget {
  const _DragBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color(0xff9a9a9a)),
      margin: const EdgeInsets.fromLTRB(
        140, 15, 206, 14
      ),
      );
  }
}

class DownloadPanel extends StatelessWidget {
  const DownloadPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 3, child: Container(padding: const EdgeInsets.all(8), child: Wrap(children: const [LinkField()]))),
        Expanded(flex: 8, child: Container(padding: const EdgeInsets.all(8), child: DownloadStatus())),
        Expanded(flex: 2, child: Container(alignment: Alignment.bottomRight, padding: const EdgeInsets.all(8), child: Wrap(children: const [DownloadButton()]),))
      ],
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    downloadPack() async {
      final c = getIt<Controller>();
      final dc = getIt<DownloadController>();
      var packLink = dc.stickerLink.split('/')[dc.stickerLink.split('/').length - 1];

      var downloader = StickerDownloader('TOKEN_HERE'); //!!! TOKEN HERE

      dc.statusText.value = 'Getting pack info...';
      var stickerPack = await downloader.getPack(packLink);
      dc.statusText.value = 'Downloading stickers...';
      var asd = await downloader.downloadPack(stickerPack, '${await c.getPath()}/stickerpacks/$packLink');
      dc.statusText.value = 'Converting stickers...';
      downloader.convertPack('${await c.getPath()}/stickerpacks/$packLink', () async {
        dc.statusText.value = 'Done!';
        var coverFile = await File('${await c.getPath()}/stickerpacks/$packLink/cover.png').exists() ? 'stickerpacks/$packLink/cover.png' : 'stickerpacks/$packLink/${basename(Directory('${await c.getPath()}/stickerpacks/$packLink').listSync().first.path)}';
        c.addPack(stickerPack['title'], 'stickerpacks/$packLink', coverFile);
      });
    }


    return hHover(const Color(0xff858585), 
    GestureDetector(
      onTap: () => downloadPack(),
      child: Container(margin: const EdgeInsets.all(2), color: const Color(0xff3c3c3c), width: 100, height: 28,
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: const [
        SizedBox(height: 28, width: 28, child: Center(child: Icon(FluentSystemIcons.ic_fluent_arrow_download_regular, color: Color(0xfff2f2f2), size: 16,))),
        Text('Download', style: TextStyle(color: Color(0xfff2f2f2)),)
      ]) ,
      ),
    ),
    normalColor: const Color(0xff3c3c3c));
  }
}

class LinkField extends StatelessWidget {
  const LinkField({super.key});

  @override
  Widget build(BuildContext context) {
    final dc = getIt<DownloadController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
      Container(
          padding: const EdgeInsets.all(4),
          height: 28,
          child: FittedBox(
            alignment: Alignment.topLeft,
            fit: BoxFit.fitHeight,
            child: Text(
              'Link to sticker pack'.toUpperCase(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xffbbbbbb),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      hHover(const Color(0xff999999), Container(
        alignment: Alignment.center,
        width: 300,
        height: 32,
        margin: const EdgeInsets.all(2),
        color: const Color(0xff282828),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Theme(data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(selectionColor: Color(0x33f2f2f2))
          ),
            child: TextField(
              onChanged: (value) => dc.stickerLink = value,
              maxLines: 1,
              decoration: const InputDecoration(isDense: true, hintText: 'https://t.me/addstickers/hiostickerpack', hintStyle: TextStyle(color: Color(0x50f2f2f2)), border: InputBorder.none),
              cursorColor: const Color(0xfff2f2f2),
              style: const TextStyle(color: Color(0xfff2f2f2), fontWeight: FontWeight.normal,),

            ),
          ),
        ),
      ), normalColor: const Color(0xff666666))
      ],);
  }
}

class DownloadStatus extends StatelessWidget {
  const DownloadStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final dc = getIt<DownloadController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [Center(
        child: Container(child: hListen(dc.statusText, (value) => Text(value, style: TextStyle(
          color: Color(0x88f2f2f2),
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),)),),
      ),
    ]);
  }
}