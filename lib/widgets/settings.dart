import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tgstickers/hoosk/hoosk.dart';
import 'package:tgstickers/main.dart';
import 'package:window_manager/window_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff333333),
      body: GestureDetector(
        onTap: () async {
          final c = getIt<Controller>();

          await windowManager.hide();
          windowManager.setSize(c.lastSize);
          windowManager.setPosition(c.lastPosition);
          await windowManager.show();
          
          c.settingsOpen.value = false;
        },
        child: Container(color: Colors.blue, child: Text('Coming soon...'),)
      )
    );

    return GestureDetector(
      onTap: () async {
        final c = getIt<Controller>();

        await windowManager.hide();
        windowManager.setSize(c.lastSize);
        windowManager.setPosition(c.lastPosition);
        await windowManager.show();
        
        c.settingsOpen.value = false;
      },
      child: Container(color: Colors.blue, child: Text('Coming soon...'),)
    );
  }
}