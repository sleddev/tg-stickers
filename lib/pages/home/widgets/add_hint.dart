import 'dart:math' as math;

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

class AddReminder extends StatelessWidget {
  const AddReminder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 70,
            width: 70,
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(
                FluentSystemIcons.ic_fluent_arrow_up_regular,
                color: theme.hintColor,
                size: 70,
              ),
            ),
          ),
        ),
        Text(
          "You don't have any stickers",
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 22,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          'Click the "+" button to add a new sticker pack.',
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 16,
          ),
        )
      ],
    );

  }
}