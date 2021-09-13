import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:linn01/components/ln_amount_field.dart';
import 'package:linn01/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

import '../components/ln_text_field.dart';
import '../constants.dart';
// import '../components/datetime_picker.dart';

class NewDonation extends StatefulWidget {
  const NewDonation({Key? key}) : super(key: key);

  @override
  _NewDonationState createState() => _NewDonationState();
}

class _NewDonationState extends State<NewDonation> {
  CollectionReference donations =
      FirebaseFirestore.instance.collection('donations');
  final TextEditingController _titleController =
      TextEditingController(text: '');
  final TextEditingController _amountController =
      TextEditingController(text: '');

  Future<void> addDonation() {
    return donations
        .add({
          'title': _titleController.text,
          'amount': _amountController.text,
          'date': DateFormat('MMM yy', 'de').format(DateTime.now()),
        })
        .then((value) => debugPrint("Donation Added"))
        .catchError((error) => debugPrint("Failed to add Donation: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Abbrechen',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
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
                  margin: const EdgeInsets.only(right: 4),
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    onPressed: () {
                      addDonation();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Fertig',
                      style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
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
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: LnTextField(
                hintText: 'Spende an',
                controller: _titleController,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: fontColor),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(18),
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
                      child: Text(
                          'seit ${DateFormat('MMM yy', 'de').format(DateTime.now())}'),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: LnAmountField(
                      hintText: '0,00 €',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'de_de',
                          decimalDigits: 2,
                          symbol: '€',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
