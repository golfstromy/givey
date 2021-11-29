import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:linn01/components/ln_amount_field.dart';
import 'package:linn01/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

import '../components/ln_text_field.dart';
import '../constants.dart';

// import '../components/datetime_picker.dart';
var currentUser = FirebaseAuth.instance.currentUser;

var userId = currentUser!.uid;

class NewDonation extends StatefulWidget {
  // final Donation donation;
  NewDonation({this.title = '', this.amount = '', this.donationId, Key? key})
      : super(key: key);

  String title;
  String amount;
  String? donationId;

  printAll() {}

  @override
  _NewDonationState createState() => _NewDonationState();
}

class _NewDonationState extends State<NewDonation> {
  CollectionReference donations = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('donations');

  late final TextEditingController _amountController =
      TextEditingController(text: widget.amount);

  late final TextEditingController _titleController =
      TextEditingController(text: widget.title);

  Future<void> addDonation() async {
    // var uuid = await getDeviceUniqueId();
    return donations
        .add({
          'title': _titleController.text,
          'amount': _amountController.text,
          'date': DateFormat('MMM yy', 'de').format(DateTime.now()),
          'timestamp': DateTime.now(),
          'active': 'true',
        })
        .then((value) => debugPrint(value.id))
        .catchError((error) => debugPrint('Failed to add Donation: $error'));
  }

  Future<void> editDonation() async {
    return donations
        .doc(widget.donationId)
        .update({
          'title': _titleController.text,
          'amount': _amountController.text,
          'date': DateFormat('MMM yy', 'de').format(DateTime.now()),
        })
        .then((value) => print('Donation Updated'))
        .catchError((error) => print('Failed to update donation: $error'));
  }

  Future<void> stopDonation() async {
    return donations
        .doc(widget.donationId)
        .update({
          'active': 'false',
        })
        .then((value) => print('Donation stopped!'))
        .catchError((error) => print('Failed to stop donation: $error'));
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
                    child: (widget.donationId != null)
                        ? const Text(
                            'Delete',
                            style: TextStyle(color: deleteColor, fontSize: 20),
                          )
                        : const Text(
                            'Cancel',
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
                    'New Donation',
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
                      if (widget.donationId != null) {
                        editDonation();
                      } else {
                        addDonation();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Done',
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
