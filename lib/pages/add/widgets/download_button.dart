import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

class DownloadButton extends StatefulWidget {
  final Function()? onTap;

  const DownloadButton({
    Key? key,
    this.onTap
  }) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
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
          width: 108,
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: Icon(
                  FluentSystemIcons.ic_fluent_arrow_download_regular,
                  color: theme.iconColor,
                  size: 16,
                ),
              ),
              Text('Download', style: TextStyle(color: theme.inputTextColor),)
            ],
          ),
        ),
      ),
    );
  }
}