import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:super_clipboard/super_clipboard.dart';
import 'package:tgstickers/providers/settings_provider.dart';
import 'package:tgstickers/providers/toast_provider.dart';

class ClipboardProvider {
  final ToastProvider toastProvider;
  final SettingsProvider settingsProvider;

  ClipboardProvider(this.toastProvider, this.settingsProvider);

  Future<void> copySticker(File imageFile) async {
    var baseDir = imageFile.parent;
    var imageBytes = await imageFile.readAsBytes();

    if (settingsProvider.copySize.value != 512) {
      baseDir = Directory(p.join(baseDir.path, "resize_cache",
          settingsProvider.copySize.value.toString()));
      await baseDir.create(recursive: true);
      var targetFile = File(p.join(baseDir.path, p.basename(imageFile.path)));
      imageFile = targetFile;

      if (!targetFile.existsSync()) {
        var originalImage = img.decodePng(imageBytes)!;
        var width = originalImage.width;
        var height = originalImage.height;
        var copySize = settingsProvider.copySize.value;
        var resized = img.copyResize(originalImage,
            maintainAspect: true,
            interpolation: img.Interpolation.cubic,
            width: width >= height ? copySize : null,
            height: height >= width ? copySize : null);
        var resizedBytes = img.encodePng(resized);
        img.writeFile(targetFile.path, resizedBytes);
        imageBytes = resizedBytes;
      } else {
        imageBytes = await targetFile.readAsBytes();
      }
    }

    var item = DataWriterItem(suggestedName: p.basename(imageFile.path));
    if (Platform.isWindows) {
      item.add(Formats.fileUri(imageFile.uri));
    } else {
      item.add(Formats.png(imageBytes));
    }
    await SystemClipboard.instance?.write([item]);
    toastProvider.copyToast();
  }
}
