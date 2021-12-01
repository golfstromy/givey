import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:linn01/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'modals/donation.dart';

Future<Organization> fetchOrganization() async {
  final response = await http.get(Uri.parse(
      'https://autocomplete.clearbit.com/v1/companies/suggest?query=:vystem.io'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Organization.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Organization');
  }
}

class Organization {
  final int name;
  final int domain;
  final String logo;

  Organization({
    required this.name,
    required this.domain,
    required this.logo,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'],
      domain: json['domain'],
      logo: json['logo'],
    );
  }
}

var currentUser = FirebaseAuth.instance.currentUser;

var userId = currentUser!.uid;

final Stream<QuerySnapshot> _donationsStream = FirebaseFirestore.instance
    .collection('users')
    .doc(currentUser!.uid)
    .collection('donations')
    // .where('date', isEqualTo: 'Nov. 21')
    // .orderBy('timestamp', descending: true)
    // .where('active', isEqualTo: true)
    .orderBy('timestamp', descending: true)
    .snapshots();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Organization> futureOrganization;

  @override
  void initState() {
    super.initState();
    futureOrganization = fetchOrganization();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Givey',
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
                  return NewDonation();
                },
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body:
          // FutureBuilder<Organization>(
          //   future: futureOrganization,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Image.network(snapshot.data!.logo);
          //     } else if (snapshot.hasError) {
          //       return Text('${snapshot.error}');
          //     }
          //     return const CircularProgressIndicator();
          //   },
          // ),
          StreamBuilder<QuerySnapshot>(
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
                  onTap: () => {
                        showCupertinoModalBottomSheet(
                          context: context,
                          expand: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return NewDonation(
                                title: donation['title'],
                                amount: donation['amount'],
                                donationId: document.id);
                          },
                        ),
                      },
                  leading: CircleAvatar(
                      backgroundColor: circleColor,
                      child: Image.network(
                          'https://logo.clearbit.com/${donation['title']}')),
                  title: Text(
                    '${donation['title']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                      '${DateFormat('MMM', 'en').format(donation['date'].toDate())} \'${DateFormat('yy', 'en').format(donation['date'].toDate())} • monthly'),
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
