import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linn01/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'modals/newdonation.dart';

// main() with Firebase and Language

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('de', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// Firebase Connection/Stream & addDonation function

class _MyAppState extends State<MyApp> {
  CollectionReference donations =
      FirebaseFirestore.instance.collection('donations');
  final Stream<QuerySnapshot> _donationsStream =
      FirebaseFirestore.instance.collection('donations').snapshots();

  Future<void> addDonation() {
    return donations
        .add({
          'title': 'New Title',
          'amount': 42,
          'date': DateFormat('MMM yy', 'de').format(DateTime.now()),
        })
        .then((value) => print("Donation Added"))
        .catchError((error) => print("Failed to add Donation: $error"));
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Spendenapp';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Color.fromRGBO(0, 122, 255, 1.0),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            title,
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1.0),
            ),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => CupertinoButton(
                child: const Icon(CupertinoIcons.add),
                onPressed: () => showCupertinoModalBottomSheet(
                  // addDonation()
                  context: context,
                  expand: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return NewDonation();
                  },
                ),
              ),
            ),
          ],
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _donationsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return new ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: circleColor,
                      child: Text('DF'),
                    ),
                    title: Text(
                      '${data['title']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text('${data['date']} • monatlich'),
                    trailing: Text('${data['amount'].toString()} €',
                        style: const TextStyle(
                          fontSize: 17,
                        )));
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
