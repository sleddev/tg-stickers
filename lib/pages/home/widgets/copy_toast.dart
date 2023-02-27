import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

class CopyToast extends StatelessWidget {
  const CopyToast({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(116.5, 0, 116.5, 10),
        child: Container(
          decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 10, color: theme.ctShadowColor)]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: theme.ctBackgroundColor,
                border: Border.all(color: theme.ctBorderColor),
                borderRadius: BorderRadius.circular(8)
              ),
              height: 30,
              child: Row(
                children: [
                  SizedBox(width: 30, child: Icon(FluentSystemIcons.ic_fluent_copy_regular, color: theme.ctTextColor, size: 20)),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sticker copied', style: TextStyle(
                        color: theme.ctTextColor,
                        fontSize: 16
                      ))
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}