import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

typedef ListenWidgetBuilder<T> = Widget Function(T value);
typedef EachWidgetBuilder<T> = Widget Function(T item, int i);
typedef JSON = Map<String, dynamic>;

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

List<Widget> hEach<T>(Iterable<T> list, EachWidgetBuilder<T> builder) {
  List<Widget> output = [];
  for (var i = 0; i < list.length;i++) {
    output.add(builder(list.elementAt(i), i));
  }
  return output;
}

hIf() {

}

Widget hHover(Color hoverColor, Widget? child) {
  return _Hover(hoverColor: hoverColor,child: child);
}

class _Hover extends StatefulWidget {
  final Widget? child;
  final Color? hoverColor;
  const _Hover({super.key, this.child, this.hoverColor});

  @override
  State<_Hover> createState() => __HoverState();
}

class __HoverState extends State<_Hover> {
  Color? hoverColor;

  @override
  initState() {
    //hoverColor = widget.hoverColor;


    super.initState();
  }

  onEnter() {
    setState(() {
      hoverColor = widget.hoverColor;
    });
  }
  onExit() {
    setState(() {
      hoverColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return MouseRegion(
      onEnter: (event) => onEnter(),
      onExit: (event) => onExit(),
      child: Container(color: hoverColor, child: widget.child)
    );
  }
}

void main(List<String> args) {
  var asd = Writable('');
  hListen(asd, (value) => Text(value));
  
  
}