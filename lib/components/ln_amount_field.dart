import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class LnAmountField extends StatefulWidget {
  final String text;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const LnAmountField(
      {this.text = '',
      this.keyboardType = TextInputType.name,
      this.inputFormatters,
      Key? key})
      : super(key: key);

  @override
  _LnAmountFieldState createState() => _LnAmountFieldState();
}

class _LnAmountFieldState extends State<LnAmountField> {
  FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController(
      // text: '0,00€'
      );

  // void _clearTextField() {
  //   _controller.clear();
  //   setState(() {});
  // }

  @override
  void initState() {
    _focus.addListener(() {
      setState(() {});
    });
    _controller.addListener(() {
      setState(() {
        // _controller.text.isEmpty ? _controller.text = '0,00€' : null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Stack(
        //   children: [
        TextField(
      inputFormatters: widget.inputFormatters,
      // [
      //   TextInputMask(
      //       mask: '\$! !9+,999.99',
      //       placeholder: '0',
      //       maxPlaceHolders: 4,
      //       reverse: true)
      // ],
      controller: _controller,
      keyboardType: widget.keyboardType,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      focusNode: _focus,
      textAlign:
          // _focus.hasFocus ? TextAlign.left :
          TextAlign.center,
      autofocus: false,
      enableInteractiveSelection: true,
      cursorColor: Colors.transparent,
      cursorWidth: 0,
      cursorRadius: const Radius.circular(2.0),
      decoration: InputDecoration(
        hintText: _focus.hasFocus
            ? _controller.text.isNotEmpty
                ? ''
                : widget.text
            : widget.text,
        hintStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: fontColor),
        contentPadding: EdgeInsets.all(18),
        filled: true,
        fillColor: _focus.hasFocus ? Colors.white : textFieldColor,
        // suffixIcon: (_controller.text.length != 0 && _focus.hasFocus)
        //     ? IconButton(
        //         padding: EdgeInsets.all(0),
        //         icon: const Icon(CupertinoIcons.xmark_circle_fill),
        //         color: textFieldColor,
        //         onPressed: _clearTextField,
        //       )
        //     : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      //   Container(
      //     alignment: Alignment.centerRight,
      //     child: IconButton(
      //       onPressed: _clearTextField,
      //       icon: const Icon(CupertinoIcons.xmark_circle_fill),
      //       color: Colors.red,
      //     ),
      //   )
      // ],
      // )
    );
  }
}
