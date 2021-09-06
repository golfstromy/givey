import 'package:flutter/material.dart';
import '../constants.dart';

class LnTextField extends StatefulWidget {
  const LnTextField({Key? key}) : super(key: key);

  @override
  _LnTextFieldState createState() => _LnTextFieldState();
}

class _LnTextFieldState extends State<LnTextField> {
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    _focus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      // Theme.of(context).brightness == Brightness.light
      //     ? _focus.hasFocus
      //         ? Colors.white
      //         : Colors.grey[100]
      //     : _focus.hasFocus
      //         ? Colors.grey[900]
      //         : Colors.grey[900],
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          textAlign: TextAlign.center,
          autofocus: false,
          decoration: InputDecoration(
            focusColor: Colors.red,
            hintText: 'Spende an',
            hintStyle: TextStyle(fontSize: 20),
            contentPadding: EdgeInsets.all(18),
            hoverColor: Colors.white,
            filled: true,
            fillColor: textFieldColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
