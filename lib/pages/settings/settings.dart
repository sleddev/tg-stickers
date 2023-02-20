import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import 'widgets/general_tab.dart';
import 'widgets/theme_tab.dart';
import 'widgets/settings_tab.dart';
import 'widgets/titlebar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.borderColor, width: 2),
          left: BorderSide(color: theme.borderColor, width: 1),
          right: BorderSide(color: theme.borderColor, width: 1),
          top: BorderSide(color: theme.borderColor, width: 1),
        )
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          const SizedBox(
            height: 32,
            child: SettingsTitleBar(),
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: theme.leftBg,
                    child: Column(
                      children: const [
                        SettingsTab(
                          name: "general",
                          tab: GeneralTab(),
                          icon: FluentSystemIcons.ic_fluent_settings_regular,
                        ),
                        SettingsTab(
                          name: "theme",
                          tab: ThemeTab(),
                          icon: FluentSystemIcons.ic_fluent_paint_brush_regular,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: theme.rightBg,
                    child: settings.tabWidget ?? Container(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}