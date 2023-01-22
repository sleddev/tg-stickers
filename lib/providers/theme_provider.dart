import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  //Main
  var leftBg = const Color(0xFF3a3a3a);
  var rightBg = const Color(0xFF333333);
  var hoverColor = const Color(0x33ffffff);
  var iconColor = const Color(0xFFf2f2f2);
  var borderColor = const Color(0xFF535353);
  var dragBarColor = const Color(0xFF9a9a9a);
  var scrollBarColor = const Color(0xFF666666);
  var headerColor = const Color(0xFFbbbbbb);
  var blurColor = const Color(0x77000000);

  //CopyToast
  var ctShadowColor = const Color(0x55333333);
  var ctBorderColor = const Color(0xFF888888);
  var ctTextColor = const Color(0xFFbbbbbb);
  var ctBackgroundColor = const Color(0xFF3a3a3a);

  //InputBox
  var inputShadowColor = const Color(0x55333333);
  var inputBorderColor = const Color(0xFF555555);
  var inputTextColor = const Color(0xFFbbbbbb);
  var inputHintColor = const Color(0xFF777777);
  var inputBackgroundColor = const Color(0xFF3a3a3a);

  //AddPage
  var infoColor = const Color(0xFF777777);
  var downloadColor = const Color(0xFF777777);
  var convertColor = const Color(0xFF777777);
  var doneColor = const Color(0xFF00ff60);
  var errorColor = const Color(0xFFff5050);
}