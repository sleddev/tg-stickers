import 'package:flutter/cupertino.dart';

class AddProvider extends ChangeNotifier {
  String currentTab = 'download';
  Widget? tabWidget;

  ValueNotifier<String> localStatus = ValueNotifier('');
  ValueNotifier<String> localError = ValueNotifier('');

  void setTabWidget(Widget widget, String name) {
    tabWidget = widget;
    currentTab = name;
    notifyListeners();
  }
}