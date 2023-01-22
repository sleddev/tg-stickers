import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tgstickers/pages/home/widgets/copy_toast.dart';

class ToastProvider extends ChangeNotifier {
  Widget? toast;
  ValueNotifier<bool> visible = ValueNotifier(false);
  Duration duration = const Duration(seconds: 1);
  Duration transition = const Duration(milliseconds: 100);


  void copyToast() {
    toast = const CopyToast();
    visible.value = true;
    visible.notifyListeners();

    Timer(duration, () {
      visible.value = false;
      Timer(transition, () => hide());
    });
  }

  void hide() {
    toast = null;
  }
}