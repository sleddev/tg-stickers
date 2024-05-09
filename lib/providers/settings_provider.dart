import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'config_provider.dart';

class SettingsProvider extends ChangeNotifier {
  ConfigProvider configProvider;

  String currentTab = 'general';
  Widget? tabWidget;

  ValueNotifier<String> localStatus = ValueNotifier('');
  ValueNotifier<String> localError = ValueNotifier('');

  ValueNotifier<bool> alwaysOnTop = ValueNotifier(false);
  ValueNotifier<bool> showSearchBar = ValueNotifier(true);
  ValueNotifier<int> copySize = ValueNotifier(512);
  SettingsProvider(this.configProvider) {
    init();
  }

  Future<void> init() async {
    alwaysOnTop.value = (await configProvider.getConfig()).alwaysOnTop;
    showSearchBar.value = (await configProvider.getConfig()).showSearchBar;
    copySize.value = (await configProvider.getConfig()).copySize;
  }

  Future<void> aotSwitch(bool aot) async {
    alwaysOnTop.value = aot;

    await configProvider.updateConfig(updater: (value) async {
      value.alwaysOnTop = aot;
      return value;
    });

    await windowManager.setAlwaysOnTop(aot);
  }

  Future<void> showSearchBarSwitch(bool show) async {
    showSearchBar.value = show;

    await configProvider.updateConfig(updater: (value) async {
      value.showSearchBar = show;
      return value;
    });
  }

  Future<void> setCopySize(int size) async {
    copySize.value = size;

    await configProvider.updateConfig(updater: (value) async {
      value.copySize = size;
      return value;
    });
  }


  void setTabWidget(Widget widget, String name) {
    tabWidget = widget;
    currentTab = name;
    notifyListeners();
  }
}
