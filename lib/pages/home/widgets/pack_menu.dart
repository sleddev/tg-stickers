import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/pages/home/widgets/pack_menu_item.dart';
import 'package:tgstickers/providers/sticker_provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';
import 'package:tgstickers/utils.dart';

class PackMenu extends StatelessWidget {
  const PackMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final stickers = Provider.of<StickerProvider>(context);

    Map<String, EdgeInsets> paddingMap = {
      '': const EdgeInsets.only(left: 100, right: 100),
      'menu': const EdgeInsets.only(left: 80, right: 80),
      'delete': const EdgeInsets.only(left: 80, right: 80)
    };

    Map<String, Widget> statusMap = {
      '': Container(),
      'menu': Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 8),
            alignment: Alignment.topLeft,
            child: Text(
              stickers.menuPack!.name.toUpperCase(),
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(
                color: theme.pmTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          const SizedBox(height: 8),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: PackMenuItem(
                  text: 'Move up',
                  textColor: theme.pmTextColor,
                  onTap: () => stickers.moveUp(),
                )
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PackMenuItem(
                  text: 'Move down',
                  textColor: theme.pmTextColor,
                  onTap: () => stickers.moveDown(),
                )
              )
            ],
          ),
          const SizedBox(height: 8),
          /*PackMenuItem(
            text: 'Edit',
            textColor: theme.pmTextColor,
          ),
          const SizedBox(height: 8),*/
          PackMenuItem(
            onTap: () => stickers.setPackMenuStatus('delete'),
            text: 'Remove',
            textColor: theme.errorColor,
          )
        ],
      ),
      'delete': stickers.menuPack == null ? Container() : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Are you sure?',
            style: TextStyle(
              color: theme.pmTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500
            )
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remove ',
                  style: TextStyle(
                    color: theme.pmTextColor
                  )
                ),
                TextSpan(
                  text: stickers.menuPack!.name,
                  style: TextStyle(
                    color: theme.pmTextColor,
                    fontWeight: FontWeight.bold
                  )
                ),
                TextSpan(
                  text: ' sticker pack?',
                  style: TextStyle(
                    color: theme.pmTextColor
                  )
                )
              ]
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => stickers.packMenuDelete.value = !stickers.packMenuDelete.value,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: ValueListenableBuilder(
                      valueListenable: stickers.packMenuDelete,
                      builder: (context, delete, child) => Checkbox(
                        splashRadius: 0,
                        checkColor: theme.pmBackgroundColor,
                        fillColor: MaterialStateColor.resolveWith((states) => theme.pmTextColor),
                        value: delete,
                        onChanged: (value) => stickers.packMenuDelete.value = value ?? delete,
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      'delete files',
                      style: TextStyle(
                        color: theme.pmTextColor
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: PackMenuItem(
                    text: 'Cancel',
                    textColor: theme.pmTextColor,
                    onTap: () => stickers.setPackMenuStatus('menu'),
                  )
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PackMenuItem(
                    text: 'Yes',
                    textColor: theme.errorColor,
                    onTap: () => stickers.removePack(stickers.packMenuDelete.value),
                  )
                )
              ],
            ),
          )
        ],
      )
    };

    return ValueListenableBuilder(
      valueListenable: stickers.packMenuVisible,
      builder: (context, visible, child) => !visible ? Container() : Fade(
        notifier: stickers.packMenuOpen,
        duration: stickers.packMenuTransition,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => stickers.hidePackMenu(),
          child: Blur(
            blurColor: theme.pmBlurColor,
            overlay: ValueListenableBuilder(
              valueListenable: stickers.packMenuStatus,
              builder: (context, status, child) => Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                padding: paddingMap[status],
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.pmBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.pmBorderColor),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: statusMap[status]
                    ),
                  ),
                ),
              )
            ),
            child: Container(),
          ),
        ),
      )
    );
  }
}