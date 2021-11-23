import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linn01/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'home_page.dart';
import 'modals/newdonation.dart';
import './models/donation.dart';

CollectionReference donations =
    FirebaseFirestore.instance.collection('donations');
final Stream<QuerySnapshot> _donationsStream =
    FirebaseFirestore.instance.collection('donations').snapshots();

// final donationsStreamProvider =
//     StreamProvider.autoDispose<List<Donation>>((ref) {
//   final database = ref.watch(databaseProvider)!;
//   return database.donationsStream();
// });

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Spendenapp',
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => CupertinoButton(
              child: const Icon(CupertinoIcons.add),
              onPressed: () => showCupertinoModalBottomSheet(
                context: context,
                expand: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return const NewDonation();
                },
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _donationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> donation =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                  // onTap: () => showCupertinoModalBottomSheet(
                  //       context: context,
                  //       expand: true,
                  //       backgroundColor: Colors.transparent,
                  //       builder: (context) {
                  //         return const NewDonation();
                  //       },
                  //     ),
                  leading: const CircleAvatar(
                    backgroundColor: circleColor,
                    child: Text('DF'),
                  ),
                  title: Text(
                    '${donation['title']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text('${donation['date']} • monatlich'),
                  trailing: Text(donation['amount'].toString(),
                      style: const TextStyle(
                        fontSize: 17,
                      )));
            }).toList(),
          );
        },
      ),
    );
  }
}
