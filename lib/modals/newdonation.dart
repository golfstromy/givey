import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:linn01/components/ln_amount_field.dart';
import 'package:linn01/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../components/ln_text_field.dart';

class NewDonation extends StatefulWidget {
  const NewDonation({Key? key}) : super(key: key);

  @override
  _NewDonationState createState() => _NewDonationState();
}

class _NewDonationState extends State<NewDonation> {
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: LnTextField(text: 'Spende an'),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: fontColor),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.all(18),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(textFieldColor),
                        foregroundColor: MaterialStateProperty.all(fontColor),
                      ),
                      onPressed: () => {},
                      child: Text('Sept 21'),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      child: LnAmountField(
                        text: '0,00 €',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            locale: 'de_de',
                            decimalDigits: 2,
                            symbol: '\€',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 16),
            //   child: CupertinoTextField(
            //     textAlign: TextAlign.center,
            //     placeholderStyle: TextStyle(),
            //     placeholder: 'Spende an',
            //     clearButtonMode: OverlayVisibilityMode.editing,
            //     cursorColor: Theme.of(context).accentColor,
            //     enableSuggestions: false,
            //     // maxLength: 37,
            //     // maxLengthEnforcement: MaxLengthEnforcement.enforced,
            //     textInputAction: TextInputAction.next,
            //   ),
            // ),
            // Container(
            //   height: 150,
            //   child: CupertinoDatePicker(
            //     mode: CupertinoDatePickerMode.date,
            //     initialDateTime: DateTime(1969, 1, 1),
            //     onDateTimeChanged: (DateTime newDateTime) {
            //       // Do something
            //     },
            //   ),
            // ),
            // CupertinoTextField(
            //   placeholder: '0,00 €',
            //   keyboardType: TextInputType.numberWithOptions(
            //     decimal: false,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
