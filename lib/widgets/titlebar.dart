import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: DragToMoveArea(child: DragBar())
            ),
            SizedBox(
              width: 45,
              height: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: const Color(0xff9f9f9f),
                  splashColor: Colors.transparent,
                  hoverColor: const Color(0xff5b5b5b),
                  onHighlightChanged: (value) {},
                  onHover: (value) {},
                  onTap: () {},
                  child: const Icon(FluentSystemIcons.ic_fluent_settings_regular, color: Color(0xfff2f2f2), size: 18),
                ),
              ),
            ),
            WindowCaptionButton.close(brightness: Brightness.dark, onPressed: () {
              windowManager.close();
            },),
          ]
        ),
      )
    ]);
  }
}

class DragBar extends StatelessWidget {
  const DragBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color(0xff9a9a9a)),
      margin: const EdgeInsets.fromLTRB(
        140, 15, 115, 14
      ),
      );
  }
}