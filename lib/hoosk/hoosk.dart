import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

typedef ListenWidgetBuilder<T> = Widget Function(T value);
typedef EachWidgetBuilder<T> = Widget Function(T item, int i);
typedef JSON = Map<String, dynamic>;

//TODO: Use StatelessWidgets

Widget hListen<T>(Writable<T> writable, ListenWidgetBuilder<T> builder) {
  return ValueListenableBuilder(
    valueListenable: writable,
    builder: (context, value, child) {
      return builder(value);
    }
  );
}


T getIt<T extends Object>() {
  return GetIt.I<T>();
}

class Writable<T> extends ValueNotifier<T> {
  Writable(T value) : super(value);
}

List<Widget> hEach<T>(Iterable<T> list, EachWidgetBuilder<T> builder, {Widget? separator}) {
  List<Widget> output = [];
  for (var i = 0; i < list.length;i++) {
    output.add(builder(list.elementAt(i), i));
    if (separator != null && i != list.length - 1) output.add(separator);
  }
  return output;
}

hIf() {

}

Widget hHover(Color hoverColor, Widget? child, {Color normalColor = Colors.transparent}) {
  return _Hover(hoverColor, child, normalColor);
}

class _Hover extends StatelessWidget {
  const _Hover(this.hoverColor, this.child, this.normalColor, {super.key});
  final Color hoverColor;
  final Color normalColor;
  final Widget? child;
  

  @override
  Widget build(BuildContext context) {
    var currentColor = Writable<Color?>(normalColor);

    onEnter() {
      currentColor.value = hoverColor;
    }
    onExit() {
      currentColor.value = normalColor;
    }

    return MouseRegion(
      onEnter: (event) => onEnter(),
      onExit: (event) => onExit(),
      child: hListen(currentColor, (value) =>  Container(color: value, child: child))
    );
  }
}

Widget hFade(Writable<bool> writable, int duration, Widget child) {
  var _widget = Writable<Widget>(Container());
  writable.addListener(() {
    if (!writable.value) {
      Timer(Duration(milliseconds: duration), () {
        _widget.value = Container();
        
      },);
    } else {
      _widget.value = child;
    }
  },);

  return hListen(writable,(value) => AnimatedOpacity(opacity: value ? 1 : 0, duration: Duration(milliseconds: duration), child: value ? child : hListen(_widget, (value) => value),));
}

void main(List<String> args) {
  var asd = Writable('');
  hListen(asd, (value) => Text(value));
  
  
}