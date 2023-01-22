import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/sticker_provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

import '../../../utils.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);

    final scrollController = ScrollController();

    return Container(color: theme.leftBg,
      child: RawScrollbar(
        controller: scrollController,
        thumbColor: theme.scrollBarColor,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            controller: scrollController,
            itemCount: stickers.stickerPacks.length,
            itemBuilder: (context, index) => AspectRatio(aspectRatio: 1 / 1,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: stickers.stickerPacks[index].id == stickers.selectedPack?.id ? theme.rightBg : Colors.transparent,
                    child: Hover(theme.hoverColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: GestureDetector(
                          onTap: () => stickers.changePack(index: index),
                          child: Image.file(
                            stickers.stickerPacks[index].coverFile,
                            filterQuality: FilterQuality.medium,
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}