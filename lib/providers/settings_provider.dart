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
  SettingsProvider(this.configProvider) {
    init();
  }

  Future<void> init() async {
    alwaysOnTop.value = (await configProvider.getConfig()).alwaysOnTop;
  }

  Future<void> aotSwitch(bool aot) async {
    alwaysOnTop.value = aot;
    
    await configProvider.updateConfig(updater: (value) async {
      value.alwaysOnTop = aot;
      return value;
    });

    await windowManager.setAlwaysOnTop(aot);
  }

  void setTabWidget(Widget widget, String name) {
    tabWidget = widget;
    currentTab = name;
    notifyListeners();
  }
}