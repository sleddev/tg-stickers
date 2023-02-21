import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../../providers/keyboard_provider.dart';
import 'add_hint.dart';
import 'big_sticker.dart';
import 'pack_menu.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/toast_provider.dart';
import '../../../providers/sticker_provider.dart';
import '../../../utils.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({super.key});

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  String pack = '';
  String query = '';
  var searchController = TextEditingController(text: '');
  var searchFocus = FocusNode();
  var textFieldFocus = FocusNode();
  var noResult = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);
    final toast = Provider.of<ToastProvider>(context);

    if (stickers.stickerPacks.isEmpty) return const AddReminder();

    var scrollController = AdjustableScrollController(20);

    if (stickers.selectedPack == null || stickers.selectedPackWidgets == null) return Container();
    if (pack == '') pack = stickers.selectedPack!.id;
    if (pack != stickers.selectedPack!.id) {
      searchController.text = '';
      pack = stickers.selectedPack!.id;
      searchFocus.requestFocus();
      if (mounted) setState(() => noResult = false);
    }

    var searchColor = noResult ? Color.alphaBlend(theme.sbErrorOverlay, theme.sbBackgroundColor) : theme.sbBackgroundColor;

    return Stack(
      children: [
        stickers.selectedPackWidgets!.isEmpty ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 48),
                child: Text(
                  'Pack is empty or not found',
                  style: TextStyle(
                    color: theme.hintColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                  ),
                ),
              ),
            )
          ],
        ) :
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
                            child: (stickers.filteredWidgets ?? []).isEmpty ? stickers.selectedPackWidgets![index].value : stickers.filteredWidgets![index].value,
                          ),
                        ),
                      ),
                      childCount: (stickers.filteredWidgets ?? []).isEmpty ? stickers.selectedPackWidgets!.length : stickers.filteredWidgets!.length
                    ),
                  ),
                ),
                stickers.selectedPackWidgets!.isEmpty ? const SliverPadding(padding: EdgeInsets.all(0)) : const SliverPadding(padding: EdgeInsets.only(top: 48))
              ],
            ),
          ),
        ),
        Align( //Search bar
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 10, color: theme.ctShadowColor)]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.sbBorderColor),
                    color: searchColor
                  ),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      Icon(FluentSystemIcons.ic_fluent_search_regular, color: theme.sbTextColor, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Focus(
                          focusNode: searchFocus,
                          onFocusChange: (value) {
                            if (value) textFieldFocus.requestFocus();
                          },
                          child: TextField(
                            focusNode: textFieldFocus,
                            autofocus: true,
                            controller: searchController,
                            onChanged: (value) {
                              query = value;
                              stickers.filterCurrentPack(value);
                              if (mounted) setState(() => noResult = (stickers.filteredWidgets ?? []).isEmpty);
                            },
                            maxLines: 1,
                            cursorColor: theme.inputTextColor,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Search in current pack...',
                              hintStyle: TextStyle(
                                color: theme.inputHintColor
                              )
                            ),
                            style: TextStyle(
                              color: theme.sbTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            searchController.clear();
                            stickers.filteredWidgets = [];
                            setState(() => noResult = false);
                            searchFocus.requestFocus();
                          },
                          child: WindowCaptionButtonIcon(name: 'images/ic_chrome_close.png', color: theme.sbTextColor)
                        ),
                      )
                    ],
                  ),
                ),
              ),
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