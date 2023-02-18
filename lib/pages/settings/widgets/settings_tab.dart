import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/settings_provider.dart';

class SettingsTab extends StatelessWidget {
  final IconData icon;
  final String name;
  final Widget tab;

  const SettingsTab({required this.icon, required this.name, required this.tab, super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (settings.tabWidget == null) settings.setTabWidget(tab, name);
    });

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: () => settings.setTabWidget(tab, name),
            child: Container(
              color: settings.currentTab == name ? theme.rightBg : theme.leftBg,
              child: Hover(theme.hoverColor,
                child: Icon(icon, color: theme.iconColor, size: 18)
              ),
            ),
          ),
        ),
      ),
    );
  }
}