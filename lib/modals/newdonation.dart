import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:linn01/constants.dart';

import '../components/ln_text_field.dart';

class NewDonation extends StatelessWidget {
  const NewDonation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Abbrechen',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Neue Spende',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: '.SF UI Display',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 4),
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Fertig',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: circleColor.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            LnTextField(),
            CupertinoTextField(
              placeholder: 'Spende an',
              clearButtonMode: OverlayVisibilityMode.editing,
              cursorColor: Theme.of(context).accentColor,
              enableSuggestions: false,
              maxLength: 37,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textInputAction: TextInputAction.next,
            ),
            Container(
              height: 150,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(1969, 1, 1),
                onDateTimeChanged: (DateTime newDateTime) {
                  // Do something
                },
              ),
            ),
            CupertinoTextField(
              placeholder: '0,00 €',
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
