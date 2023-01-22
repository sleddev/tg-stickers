import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

class LocalButton extends StatefulWidget {
  final Function()? onTap;

  const LocalButton({
    Key? key,
    this.onTap
  }) : super(key: key);

  @override
  State<LocalButton> createState() => _LocalButtonState();
}

class _LocalButtonState extends State<LocalButton> {
  bool hovered = false;

  void onEnter() {
    if (mounted) setState(() => hovered = true);
  }
  void onExit() {
    if (mounted) setState(() => hovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    Color borderColor = hovered ? Color.alphaBlend(theme.hoverColor, theme.inputBorderColor) : theme.inputBorderColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEnter(),
      onExit: (event) => onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor)
          ),
          height: 32,
          width: 102,
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: Icon(
                  FluentSystemIcons.ic_fluent_add_regular,
                  color: theme.iconColor,
                  size: 16,
                ),
              ),
              Text('Add pack', style: TextStyle(color: theme.inputTextColor),)
            ],
          ),
        ),
      ),
    );
  }
}