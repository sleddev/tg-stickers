import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/pages/home/widgets/add_hint.dart';
import 'package:tgstickers/pages/home/widgets/big_sticker.dart';
import 'package:tgstickers/pages/home/widgets/pack_menu.dart';
import 'package:tgstickers/providers/theme_provider.dart';
import 'package:tgstickers/providers/toast_provider.dart';

import '../../../providers/sticker_provider.dart';
import '../../../utils.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);
    final toast = Provider.of<ToastProvider>(context);

    var scrollController = AdjustableScrollController(20);

    if (stickers.selectedPack == null) return Container();
    return stickers.stickerPacks.isEmpty ?
    const AddReminder() :
    Stack(
      children: [
        RawScrollbar(
          thumbColor: theme.scrollBarColor,
          controller: scrollController,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter( //Header
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 28,
                    child: FittedBox(
                      alignment: Alignment.topLeft,
                      fit: BoxFit.fitHeight,
                      child: Text(
                        stickers.selectedPack!.name.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: theme.headerColor,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ),
                stickers.selectedPackWidgets == null ? SliverToBoxAdapter(child: Container()) : //Sticker grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 2, crossAxisSpacing: 2),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hover(theme.hoverColor,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: stickers.selectedPackWidgets![index],
                          ),
                        ),
                      ),
                      childCount: stickers.selectedPackWidgets!.length
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: stickers.bigStickerVisible,
          builder: (_, __, ___) => const BigSticker(),
        ),
        ValueListenableBuilder(
          valueListenable: toast.visible, 
          builder: (_, __, ___) => Fade(
            duration: toast.transition,
            notifier: toast.visible,
            child: toast.toast ?? Container()
          )
        ),
        const PackMenu()
      ],
    );
  }
}