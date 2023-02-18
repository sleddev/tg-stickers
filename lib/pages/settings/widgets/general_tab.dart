import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart';

class GeneralTab extends StatelessWidget {
  const GeneralTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'GENERAL',
            style: TextStyle(
              color: theme.headerColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: ValueListenableBuilder(
                        valueListenable: settings.alwaysOnTop,
                        builder: (context, aot, child) => Checkbox(
                          splashRadius: 0,
                          checkColor: theme.pmBackgroundColor,
                          fillColor: MaterialStateColor.resolveWith((states) => theme.pmTextColor),
                          value: aot,
                          onChanged: (value) async => await settings.aotSwitch(value ?? aot),
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        'Always on top',
                        style: TextStyle(
                          color: theme.pmTextColor
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}