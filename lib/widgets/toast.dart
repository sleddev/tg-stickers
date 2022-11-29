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
          padding: EdgeInsets.fromLTRB(90, 0, 90, 10),
          child: Container(
            decoration: BoxDecoration(boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 10, color: Color(0x55000000))]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 40,
                color: Colors.grey[500],
                child: Row(
                  children: [
                    SizedBox(width: 40, child: Icon(c.toastIcon.value, color: Colors.white, size: 25,)),
                    Expanded(child: Center(child: Text(message, style: TextStyle(color: Colors.white, fontSize: 20),)))
                  ])
              ),
            ),
          ),
        )
      ]
    );
  }
}