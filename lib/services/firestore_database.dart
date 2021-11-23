// import 'dart:async';

// import 'package:firestore_service/firestore_service.dart';
// import '../services/firestore_path.dart';
// import '../models/donation.dart';

// String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

// class FirestoreDatabases {
//   FirestoreDatabase({required this.uid});
//   final String uid;

//   final _service = FirestoreService.instance;

//   Future<void> setDonation(Donation donation) => _service.setData(
//         path: FirestorePath.donation(uid, donation.id),
//         data: donation.toMap(),
//       );

//   Future<void> deleteDonation(Donation donation) async {
//     // delete where entry.donationId == donation.donationId
//     final allEntries = await entriesStream(donation: donation).first;
//     for (final entry in allEntries) {
//       if (entry.donationId == donationId) {
//         await deleteEntry(entry);
//       }
//     }
//     // delete donation
//     await _service.deleteData(path: FirestorePath.donation(uid, donationId));
//   }

//   Stream<Donation> donationStream({required String donationID}) =>
//       _service.documentStream(
//         path: FirestorePath.donation(uid, donationId),
//         builder: (data, documentId) => Donation.fromMap(data, documentId),
//       );

//        Stream<Donation> donationsStream({required String donationID}) =>
//       _service.collectionStream(
//         path: FirestorePath.donations(uid),
//         builder: (data, documentId) => Donation.fromMap(data, documentId),
//       );


  
// }
