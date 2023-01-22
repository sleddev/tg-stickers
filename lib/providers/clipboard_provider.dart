import 'dart:io';

import 'package:path/path.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:tgstickers/providers/toast_provider.dart';

class ClipboardProvider {
  final ToastProvider toastProvider;

  ClipboardProvider(this.toastProvider);

  Future<void> copySticker(File imageFile) async {
      var imageBytes = await imageFile.readAsBytes();
      var item = DataWriterItem(suggestedName: basename(imageFile.path));
      if (Platform.isWindows) {
        item.add(Formats.fileUri(imageFile.uri));
      } else {
        item.add(Formats.png(imageBytes));
      }
      await ClipboardWriter.instance.write([item]);
      toastProvider.copyToast();
  }
}