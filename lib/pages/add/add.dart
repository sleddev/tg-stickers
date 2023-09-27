import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/pages/add/widgets/add_tab.dart';
import 'package:tgstickers/pages/add/widgets/download_tab.dart';
import 'package:tgstickers/pages/add/widgets/local_tab.dart';
import 'package:tgstickers/pages/add/widgets/titlebar.dart';
import 'package:tgstickers/providers/add_provider.dart';
import 'package:tgstickers/providers/window_provider.dart';
import 'package:tgstickers/utils.dart';

import '../../providers/theme_provider.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final windows = Provider.of<WindowProvider>(context);
    final add = Provider.of<AddProvider>(context);

    return ValueListenableBuilder(
      valueListenable: windows.addVisible,
      builder: (context, value, child) => !value ? Container() : Fade(
        duration: windows.addTransition,
        notifier: windows.addOpen,
        child: Flex(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 32, child: AddTitleBar()),
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: theme.leftBg,
                      child: const Column(
                        children: [
                          AddTab(
                            icon: FluentSystemIcons.ic_fluent_arrow_download_regular,
                            name: 'download',
                            tab: DownloadTab()
                          ),
                          AddTab(
                            icon: FluentSystemIcons.ic_fluent_folder_regular,
                            name: 'local',
                            tab: LocalTab()
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: theme.rightBg,
                      child: add.tabWidget ?? Container(),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}