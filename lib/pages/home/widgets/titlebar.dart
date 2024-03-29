import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../../utils.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/window_provider.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

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
                onTap: () => window.showAdd(),
                child: Hover(theme.hoverColor,
                  child: Icon(
                    FluentSystemIcons.ic_fluent_add_regular,
                    color: theme.iconColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          )
        ),
        Expanded(flex: 6, child: 
          Container(
            color: theme.rightBg,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (details) => windowManager.startDragging(),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(left: 32),
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
                  ),
                )),
                SizedBox(
                  width: 46,
                  height: double.infinity,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: window.showSettings,
                      child: Hover(theme.hoverColor,
                        child: Icon(
                          FluentSystemIcons.ic_fluent_settings_regular,
                          color: theme.iconColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ), //Settings button
                ),
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