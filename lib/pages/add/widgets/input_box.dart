import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class InputBox extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final String hint;

  const InputBox({
    Key? key,
    this.hint = '',
    this.controller,
    this.focusNode,
    this.autofocus
  }) : super(key: key);

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  Color? borderColor;
  bool hovered = false;
  bool autofocus = false;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    autofocus = widget.autofocus ?? false;
    super.initState();
  }

  void onEnter() {
    if (mounted) setState(() => hovered = true);
  }
  void onExit() {
    if (mounted) setState(() => hovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    if (widget.controller != null) controller = widget.controller!;

    void calculateColor() {
      borderColor = hovered || focusNode.hasFocus ? Color.alphaBlend(theme.hoverColor, theme.inputBorderColor) : theme.inputBorderColor;
      setState(() {});
    }
    calculateColor();

    return Focus(
      onFocusChange: (value) => calculateColor(),
      child: MouseRegion(
        onEnter: (event) => onEnter(),
        onExit: (event) => onExit(),
        child: Container(
          padding: const EdgeInsets.only(left: 4, right: 4),
          decoration: BoxDecoration(
            color: theme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor!)
          ),
          height: 32,
          child: TextField(
            autofocus: autofocus,
            focusNode: focusNode,
            controller: controller,
            maxLines: 1,
            cursorColor: theme.inputTextColor,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: theme.inputHintColor
              )
            ),
            style: TextStyle(
              color: theme.inputTextColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}