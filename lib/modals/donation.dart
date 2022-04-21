import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:linn01/components/gv_amount_field.dart';
import 'package:linn01/constants.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

import '../components/gv_text_field.dart';
import '../constants.dart';
import '../services/fetch_logo.dart';

// import '../components/datetime_picker.dart';
var currentUser = FirebaseAuth.instance.currentUser;

var userId = currentUser!.uid;

class NewDonation extends StatefulWidget {
  // final Donation donation;
  const NewDonation(
      {this.title = '', this.amount = '', this.donationId, Key? key})
      : super(key: key);

  final String title;
  final String amount;
  final String? donationId;

  @override
  _NewDonationState createState() => _NewDonationState();
}

class _NewDonationState extends State<NewDonation> {
  CollectionReference donations = FirebaseFirestore.instance
      .collection('users')
      // .doc('mockup2')
      .doc(userId)
      .collection('donations');

  late final TextEditingController _amountController =
      TextEditingController(text: widget.amount);

  late final TextEditingController _titleController =
      TextEditingController(text: widget.title);

  DateTime selectedDate = DateTime.now();

// todo test keyboard vs datepicker
  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context);
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    // TODO localization!
    // helpText: 'Select booking date',
    // cancelText: 'Not now',
    // confirmText: 'Book',
    // errorFormatText: 'Enter valid date',
    // errorInvalidText: 'Enter date in valid range',
    // fieldLabelText: 'Booking date',
    // fieldHintText: 'mm/dd/yyyy');
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (picked) {
                  if (picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                initialDateTime: selectedDate,
                minimumYear: 1900,
                maximumYear: 2025,
              ));
        });
  }

  Future<void> addDonation() async {
    return donations
        .add({
          'title': _titleController.text,
          'amount': _amountController.text,
          'date': selectedDate,
          // DateFormat('MMM yy', 'de').format(DateTime.now()),
          'timestamp': DateTime.now(),
          'active': true,
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
          'date': selectedDate,
        })
        .then((value) => debugPrint('Donation Updated'))
        .catchError((error) => debugPrint('Failed to update donation: $error'));
  }

  Future<void> deleteDonation() async {
    return donations
        .doc(widget.donationId)
        .delete()
        .then((value) => debugPrint('Donation deleted!'))
        .catchError((error) => debugPrint('Failed to stop donation: $error'));
  }

  @override
  void initState() {
    _titleController.addListener(() {
      setState(() {});
    });
    super.initState();
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
                    onPressed: () {
                      if (widget.donationId != null) {
                        deleteDonation();
                      }
                      Navigator.pop(context);
                    },
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
                  // TODO boilerplate
                  child: (widget.donationId != null)
                      ? const Text(
                          'Edit Donation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: '.SF UI Display',
                          ),
                        )
                      : const Text(
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
            FutureBuilder(
                future: fetchLogo(_titleController.text),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return Center(
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.network(snapshot.data!),
                              )));
                    } else {
                      return Container();
                    }
                  } else {
                    return Container(
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: (_titleController.text.length > 2)
                              ? Container(
                                  color: accentColor,
                                  width: 56,
                                  height: double.infinity,
                                  child: Center(
                                      child: Text(_titleController.text[0],
                                          // textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 60,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ))))
                              : Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: circleColor.withOpacity(0.5),
                                      blurRadius: 20,
                                    )
                                  ]),
                                  width: 56,
                                  height: double.infinity,
                                ),
                        ));
                    // Container(
                    //   margin: const EdgeInsets.symmetric(vertical: 30),
                    //   width: 100,
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //     color: circleColor,
                    //     shape: BoxShape.circle,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: circleColor.withOpacity(0.5),
                    //         blurRadius: 20,
                    // //       ),
                    //     ],
                    //   ),
                    // );
                  }
                }),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: GvTextField(
                hintText: 'Donate to',
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
                      onPressed: () => _selectDate(context),
                      child: Text(
                          // Todo localization
                          // '${DateFormat('MMM', 'en').format(selectedDate)} \'${DateFormat('yy', 'en').format(selectedDate)}'),
                          '${DateFormat('MMM', 'de').format(selectedDate)} \'${DateFormat('yy', 'de').format(selectedDate)}'),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: GvAmountField(
                      hintText: '0,00 £',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'de_de',
                          decimalDigits: 2,
                          symbol: '£',
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
