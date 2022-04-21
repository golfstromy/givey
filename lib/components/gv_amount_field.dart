import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class GvAmountField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  const GvAmountField(
      {this.hintText = '',
      required this.controller,
      this.keyboardType = TextInputType.name,
      this.inputFormatters,
      Key? key})
      : super(key: key);

  @override
  _GvAmountFieldState createState() => _GvAmountFieldState();
}

class _GvAmountFieldState extends State<GvAmountField> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();

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
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      focusNode: _focus,
      textAlign: TextAlign.center,
      autofocus: false,
      enableInteractiveSelection: true,
      cursorColor: Colors.transparent,
      cursorWidth: 0,
      cursorRadius: const Radius.circular(2.0),
      decoration: InputDecoration(
        hintText: _focus.hasFocus
            ? _controller.text.isNotEmpty
                ? ''
                : widget.hintText
            : widget.hintText,
        hintStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: fontColor),
        contentPadding: const EdgeInsets.all(18),
        filled: true,
        fillColor: _focus.hasFocus ? Colors.white : textFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
