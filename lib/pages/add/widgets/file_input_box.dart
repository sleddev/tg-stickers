import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgstickers/providers/theme_provider.dart';

class FileInputBox extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final bool isFile;
  final Function()? onFolderTap;

  const FileInputBox({
    Key? key,
    this.hint = '',
    this.isFile = false,
    this.controller,
    this.onFolderTap,
  }) : super(key: key);

  @override
  State<FileInputBox> createState() => _FileInputBoxState();
}

class _FileInputBoxState extends State<FileInputBox> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  Color? borderColor;
  bool hovered = false;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
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
          decoration: BoxDecoration(
            color: theme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor!)
          ),
          height: 32,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: TextField(
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.rightBg,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onFolderTap,
                    child: Container(
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: borderColor!, width: 0.0))),
                      child: Icon(
                        !widget.isFile ? FluentSystemIcons.ic_fluent_folder_open_regular 
                        : FluentSystemIcons.ic_fluent_document_regular,
                        color: theme.inputTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}