import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../../utils.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/window_provider.dart';

class SettingsTitleBar extends StatelessWidget {
  const SettingsTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final window = Provider.of<WindowProvider>(context);

    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(flex: 1, child: 
          Container(
            height: double.infinity,
            color: theme.leftBg,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => window.hideSettings(),
                child: Hover(theme.hoverColor,
                  child: Icon(
                    FluentSystemIcons.ic_fluent_arrow_left_regular,
                    color: theme.iconColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          )
        ),
        Expanded(flex: 9, child: 
          Container(
            color: theme.rightBg,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: DragToMoveArea(child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        width: 32,
                        height: 3,
                        color: theme.dragBarColor
                      ),
                    ),
                  ),
                  ),
                )),
                SizedBox(
                  width: 46,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: WindowCaptionButton.close(
                      brightness: Brightness.dark,
                      onPressed: () => windowManager.close(),
                    ),
                  ),
                )
              ]
            ),
          )
        )
      ],
    );
  }
}