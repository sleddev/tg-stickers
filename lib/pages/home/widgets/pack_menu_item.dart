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

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 32,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Hover(
            theme.hoverColor,
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}