import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

import '../../../providers/add_provider.dart';
import '../../../providers/config_provider.dart';
import '../../../providers/sticker_provider.dart';
import 'file_input_box.dart';
import 'input_box.dart';
import 'local_button.dart';

class LocalTab extends StatelessWidget {
  const LocalTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final config = Provider.of<ConfigProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);
    final add = Provider.of<AddProvider>(context);

    final pathController = TextEditingController();
    final coverController = TextEditingController();
    final nameController = TextEditingController();
    final titleController = TextEditingController();

    Map<String, Widget> statusWidgets = {
      '': Container(),
      'error': ValueListenableBuilder(
        valueListenable: add.localError,
        builder: (context, value, child) => Text(
          value,
          style: TextStyle(
            color: theme.errorColor,
            fontWeight: FontWeight.w500,
            fontSize: 15
          ),
        ),
      ),
      'done': Text(
        'Done!',
        style: TextStyle(
          color: theme.doneColor,
          fontWeight: FontWeight.w500,
          fontSize: 15
        ),
      )
    };

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.topLeft,
              child: Text(
                'PACK TITLE',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: theme.headerColor,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: InputBox(controller: titleController, hint: 'Hioshi The Enfield',),
          ),
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.topLeft,
              child: Text(
                'PACK NAME/ID',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: theme.headerColor,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: InputBox(controller: nameController, hint: 'hiostickerpack',),
          ),
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.topLeft,
              child: Text(
                'PATH TO STICKER PACK',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: theme.headerColor,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FileInputBox(
              controller: pathController,
              hint: 'C:\\...\\stickerpacks\\hiostickerpack',
              onFolderTap: () async {
                String? res = await FilePicker.platform.getDirectoryPath(
                  dialogTitle: 'Path to sticker pack',
                  initialDirectory: await config.getPath(),
                  lockParentWindow: true
                );
                pathController.text = res ?? pathController.text;
              },
            ),
          ),
          SizedBox(
            height: 18,
            width: double.infinity,
            child: FittedBox(
              alignment: Alignment.topLeft,
              child: Text(
                'PATH TO COVER PHOTO',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: theme.headerColor,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FileInputBox(
              controller: coverController,
              hint: 'C:\\...\\stickerpacks\\hiostickerpack\\cover.png',
              isFile: true,
              onFolderTap: () async {
                FilePickerResult? res = await FilePicker.platform.pickFiles(
                  dialogTitle: 'Path to sticker pack',
                  initialDirectory: await config.getPath(),
                  lockParentWindow: true,
                  allowCompression: false
                );
                if (res != null) coverController.text = res.files[0].path!;
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Container()
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: add.localStatus,
                    builder: (context, value, child) => statusWidgets[value]!,
                  ),
                ),
                LocalButton(onTap: () async {
                  if (!Directory(pathController.text).existsSync()) {
                    add.localError.value = 'Invalid pack path';
                    add.localStatus.value = 'error';
                    return;
                  }
                  if (!File(coverController.text).existsSync()) {
                    add.localError.value = 'Invalid cover path';
                    add.localStatus.value = 'error';
                    return;
                  }
                  if (nameController.text.isEmpty || titleController.text.isEmpty) {
                    add.localError.value = 'Title and name cannot be empty';
                    add.localStatus.value = 'error';
                    return;
                  }

                  var path = await config.getPath();
                  stickers.addPack(
                    basePath: relative(pathController.text, from: path),
                    coverPath: relative(coverController.text, from: path),
                    id: nameController.text,
                    name: titleController.text
                  );
                  add.localStatus.value = 'done';
                }),
              ]
            ),
          )
        ],
      ),
    );
  }
}