import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';
import 'package:tgstickers/utils.dart';

class PackMenuItem extends StatelessWidget {
  final Color? textColor;
  final String text;
  final Function()? onTap;

  const PackMenuItem({required this.text, this.textColor, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Hover(theme.hoverColor,
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: theme.pmBorderColor),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}