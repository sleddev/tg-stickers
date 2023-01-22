import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdjustableScrollController extends ScrollController {
  AdjustableScrollController([int extraScrollSpeed = 40]) {
    super.addListener(() {
      ScrollDirection scrollDirection = super.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = super.offset +
            (scrollDirection == ScrollDirection.reverse
                ? extraScrollSpeed
                : -extraScrollSpeed);
        scrollEnd = min(super.position.maxScrollExtent,
            max(super.position.minScrollExtent, scrollEnd));
        jumpTo(scrollEnd);
      }
    });
  }
}

class Fade extends StatefulWidget {
  final Widget child;
  final ValueNotifier<bool> notifier;
  final Duration? duration;
  final bool start;

  const Fade({required this.notifier, required this.child, this.duration, this.start = false, super.key});

  @override
  State<Fade> createState() => _FadeState();
}

class _FadeState extends State<Fade> {
  bool visible = false;

  void update() {
    if (mounted) setState(() => visible = widget.notifier.value);

  }

  @override
  void initState() {
    setState(() => visible = widget.start);
    widget.notifier.addListener(() => update());

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => 
      Timer(const Duration(milliseconds: 5), () => setState(() => visible = widget.notifier.value)));
  }

  @override
  void dispose() {
    widget.notifier.removeListener(() => update());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: widget.duration ?? const Duration(milliseconds: 500),
      child: widget.child,
    );
  }
}

class Hover extends StatefulWidget {
  final Color hoverColor;
  final Color normalColor;
  final Widget? child;

  const Hover(this.hoverColor, {this.normalColor = Colors.transparent, this.child, super.key});

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  late Color currentColor;

  @override
  void initState() {
    currentColor = widget.normalColor;
    super.initState();
  }

  void onEnter() {
    if (mounted) setState(() => currentColor = widget.hoverColor);
  }

  void onExit() {
    if (mounted) setState(() => currentColor = widget.normalColor);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onEnter(),
      onExit: (event) => onExit(),
      child: Container(color: currentColor, child: widget.child)
    );
  }
}