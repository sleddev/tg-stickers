import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/pages/add/add.dart';
import 'package:tgstickers/pages/home/widgets/left_panel.dart';
import 'package:tgstickers/pages/home/widgets/right_panel.dart';

import '../../providers/keyboard_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/window_provider.dart';
import 'widgets/titlebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var kb = Provider.of<KeyboardProvider>(context);
    var window = Provider.of<WindowProvider>(context);

    return FocusScope(
      node: kb.scope,
      skipTraversal: true,
      onKeyEvent: kb.homeHandler,
      onFocusChange: (value) {
        if (!value && !window.addOpen.value) kb.scope.requestFocus();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.borderColor, width: 2),
            left: BorderSide(color: theme.borderColor, width: 1),
            right: BorderSide(color: theme.borderColor, width: 1),
            top: BorderSide(color: theme.borderColor, width: 1),
          )
        ),
        child: Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                const SizedBox( //Titlebar
                  height: 32,
                  width: double.infinity,
                  child: TitleBar(),
                ),
                Expanded( //Main window
                  child: Flex(
                    direction: Axis.horizontal,
                    children: const [
                      Expanded(flex: 1, child: LeftPanel()),
                      Expanded(flex: 6, child: RightPanel())
                    ],
                  ),
                )
              ],
            ),
            const AddPage()
          ],
        ),
      ),
    );
  }
}