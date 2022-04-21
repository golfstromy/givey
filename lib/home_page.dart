import 'dart:convert' as convert;
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
import 'components/gv_list_tile.dart';

var currentUser = FirebaseAuth.instance.currentUser;

var userId = currentUser!.uid;

final Stream<QuerySnapshot> _donationsStream = FirebaseFirestore.instance
    .collection('users')
    .doc(currentUser!.uid)
    // .doc('mockup2')
    .collection('donations')
    // .where('date', isEqualTo: 'Nov. 21')
    // .orderBy('timestamp', descending: true)
    .orderBy('timestamp', descending: true)
    .snapshots();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late Future<OrganizationsList> futureOrganization;

  Future<String> fetchLogo(donationTitle) async {
    var url =
        'https://autocomplete.clearbit.com/v1/companies/suggest?query=:$donationTitle';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var logoUrl = jsonResponse[0]['logo'];
      return (logoUrl);
    } else {
      return ('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => showCupertinoModalBottomSheet(
              context: context,
              expand: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return const NewDonation();
              },
            ));
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
              return FutureBuilder(
                  future: fetchLogo(donation['title']),
                  builder: (context, AsyncSnapshot<String> snapshot) {
                    // if (snapshot.connectionState == ConnectionState) {}

                    if (snapshot.hasData) {
                      ;
                    } else {
                      // Todo boilerplate listtile in separate file
                      //   return CircularProgressIndicator();
                      // }
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
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                                color: accentColor,
                                width: 56,
                                height: double.infinity,
                                child: Center(
                                  child: Text('${donation['title'][0]}',
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      )),
                                )),
                          ),
                          title: Text(
                            '${donation['title']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                              // '${DateFormat('MMM', 'en').format(donation['date'].toDate())} \'${DateFormat('yy', 'en').format(donation['date'].toDate())} • monthly'),
                              '${DateFormat('MMM', 'de').format(donation['date'].toDate())} \'${DateFormat('yy', 'de').format(donation['date'].toDate())} • monatlich'),
                          trailing: Text(donation['amount'].toString(),
                              style: const TextStyle(
                                fontSize: 17,
                              )));
                    }
                  });
            }).toList(),
          );
        },
      ),
    );
  }
}
