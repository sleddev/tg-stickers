import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/utils.dart';

import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart';

class GeneralTab extends StatelessWidget {
  const GeneralTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    var scrollController = AdjustableScrollController(20);

    return RawScrollbar(
      thumbColor: theme.scrollBarColor,
      controller: scrollController,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
                    Container(
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
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => states.contains(
                                                MaterialState.selected)
                                            ? theme.pmTextColor
                                            : theme.pmBackgroundColor),
                                    value: aot,
                                    onChanged: (value) async =>
                                        await settings.aotSwitch(value ?? aot),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Text(
                                'Always on top',
                                style: TextStyle(color: theme.pmTextColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Transform.scale(
                                scale: 0.8,
                                child: ValueListenableBuilder(
                                  valueListenable: settings.showSearchBar,
                                  builder: (context, show, child) => Checkbox(
                                    splashRadius: 0,
                                    checkColor: theme.pmBackgroundColor,
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => states.contains(
                                                MaterialState.selected)
                                            ? theme.pmTextColor
                                            : theme.pmBackgroundColor),
                                    activeColor: Colors.blue,
                                    value: show,
                                    onChanged: (value) async => await settings
                                        .showSearchBarSwitch(value ?? show),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Text(
                                'Show search bar',
                                style: TextStyle(color: theme.pmTextColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Sticker size',
                        style: TextStyle(color: theme.pmTextColor)),
                    Column(
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ValueListenableBuilder(
                                  valueListenable: settings.copySize,
                                  builder: (context, value, _) {
                                    return GestureDetector(
                                      onTap: () => settings.setCopySize(512),
                                      child: Container(
                                        color: value == 512
                                            ? theme.hoverColor
                                            : Colors.transparent,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "100% - Native (512px)",
                                          style: TextStyle(
                                              color: theme.pmTextColor),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          color: theme.pmBorderColor,
                          height: 1,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ValueListenableBuilder(
                                  valueListenable: settings.copySize,
                                  builder: (context, value, _) {
                                    return GestureDetector(
                                      onTap: () => settings.setCopySize(256),
                                      child: Container(
                                        color: value == 256
                                            ? theme.hoverColor
                                            : Colors.transparent,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "50% - Half (256px)",
                                          style: TextStyle(
                                              color: theme.pmTextColor),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          color: theme.pmBorderColor,
                          height: 1,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ValueListenableBuilder(
                                  valueListenable: settings.copySize,
                                  builder: (context, value, _) {
                                    return GestureDetector(
                                      onTap: () => settings.setCopySize(230),
                                      child: Container(
                                        color: value == 230
                                            ? theme.hoverColor
                                            : Colors.transparent,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "45% - Telegram (230px)",
                                          style: TextStyle(
                                              color: theme.pmTextColor),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          color: theme.pmBorderColor,
                          height: 1,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ValueListenableBuilder(
                                  valueListenable: settings.copySize,
                                  builder: (context, value, _) {
                                    return GestureDetector(
                                      onTap: () => settings.setCopySize(153),
                                      child: Container(
                                        color: value == 153
                                            ? theme.hoverColor
                                            : Colors.transparent,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "30% - Discord (153px)",
                                          style: TextStyle(
                                              color: theme.pmTextColor),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          color: theme.pmBorderColor,
                          height: 1,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ValueListenableBuilder(
                                  valueListenable: settings.copySize,
                                  builder: (context, value, _) {
                                    return GestureDetector(
                                      onTap: () => settings.setCopySize(160),
                                      child: Container(
                                        color: value == 160
                                            ? theme.hoverColor
                                            : Colors.transparent,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "31.25% - True Discord (160px)",
                                          style: TextStyle(
                                              color: theme.pmTextColor),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
