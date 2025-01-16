import 'dart:math';

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
  ValueNotifier<bool> globalSearch = ValueNotifier(false);
  ValueNotifier<int> copySize = ValueNotifier(512);
  SettingsProvider(this.configProvider) {
    init();
  }

  Future<void> init() async {
    final config = await configProvider.getConfig();

    alwaysOnTop.value = config.alwaysOnTop;
    showSearchBar.value = config.showSearchBar;
    globalSearch.value = config.globalSearch;
    copySize.value = config.copySize;
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
    size = max(1, min(512, size));
    copySize.value = size;

    await configProvider.updateConfig(updater: (value) async {
      value.copySize = size;
      return value;
    });
  }

  Future<void> setGlobalSearch(bool global) async {
    globalSearch.value = global;

    await configProvider.updateConfig(updater: (value) async {
      value.globalSearch = global;
      return value;
    });
  }

  void setTabWidget(Widget widget, String name) {
    tabWidget = widget;
    currentTab = name;
    notifyListeners();
  }
}
