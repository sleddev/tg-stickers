import 'package:flutter/material.dart';

import '../hoosk/hoosk.dart';
import '../main.dart';

class Toast extends StatelessWidget {
  const Toast(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    final c = getIt<Controller>();
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(116.5, 0, 116.5, 10),
          child: hFade(c.toastStatus, 100,
            Container(
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 10, color: Color(0x55333333))]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff3a3a3a),
                    border: Border.all(color: const Color(0xff888888), strokeAlign: StrokeAlign.center),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  height: 30,
                  child: Row(
                    children: [
                      SizedBox(width: 30, child: Icon(c.toastIcon.value, color: const Color(0xffbbbbbb), size: 20,)),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 1.5), child: Text(message, style: const TextStyle(color: Color(0xffbbbbbb), fontSize: 16),)),
                        ],
                      ))
                    ])
                ),
              ),
            ),
          ),
        )
      ]
    );
  }
}