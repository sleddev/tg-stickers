import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class ThemeTab extends StatelessWidget {
  const ThemeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'THEME',
            style: TextStyle(
              color: theme.headerColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Coming soon',
                style: TextStyle(
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}