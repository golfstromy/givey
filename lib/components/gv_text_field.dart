import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class GvTextField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const GvTextField(
      {this.hintText = '',
      required this.controller, // required needed - workaround?
      this.keyboardType = TextInputType.text,
      Key? key})
      : super(key: key);

  @override
  _GvTextFieldState createState() => _GvTextFieldState();
}

class _GvTextFieldState extends State<GvTextField> {
  final FocusNode _focus = FocusNode();

  void _clearTextField() {
    widget.controller.clear();
    setState(() {});
  }

  @override
  void initState() {
    _focus.addListener(() {
      setState(() {});
    });
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      focusNode: _focus,
      textAlign: TextAlign.center,
      autofocus: false,
      enableInteractiveSelection: true,
      cursorColor: cursorColor,
      cursorWidth: 2.0,
      cursorRadius: const Radius.circular(2.0),
      decoration: InputDecoration(
        hintText: _focus.hasFocus ? '' : widget.hintText,
        hintStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: fontColor),
        // contentPadding: widget.controller.text.isEmpty
        //     ? const EdgeInsets.all(18)
        //     : EdgeInsets.fromLTRB(
        //         widget.controller.text.length < 20
        //             ? 58 - widget.controller.text.length.toDouble() * 2
        //             : 18,
        //         18,
        //         18,
        //         18),
        filled: true,
        fillColor: _focus.hasFocus ? Colors.white : textFieldColor,
        suffixIcon: (widget.controller.text.isNotEmpty && _focus.hasFocus)
            ? IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(CupertinoIcons.xmark_circle_fill),
                color: textFieldColor,
                onPressed: _clearTextField,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
