import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/add_provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';
import 'package:tgstickers/utils.dart';

class AddTab extends StatelessWidget {
  final IconData icon;
  final String name;
  final Widget tab;

  const AddTab({required this.icon, required this.name, required this.tab, super.key});

  @override
  Widget build(BuildContext context) {
    final add = Provider.of<AddProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (add.tabWidget == null) add.setTabWidget(tab, name);
    });

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: () => add.setTabWidget(tab, name),
            child: Container(
              color: add.currentTab == name ? theme.rightBg : theme.leftBg,
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