// import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

// @immutable
// class Donation extends Equatable{
//   const Donation(
//       {required this.id,
//       required this.title,
//       required this.amount,
//       required this.date});
//   final String id;
//   final String title;
//   final int amount;
//   final DateTime date;
// }

// @override
// List<Object> get props => [id, title, amount, date];

// @override
// bool get stringify => true;

// factory Donation.fromMap(Map<String, dynamic>? data, String donationId) {
//   if (data == null) {
//     throw StateError('missing data for donationId: $donationId');
//   }
//   final title = data['title'] as String?;
//   if (title == null) {
//     throw StateError('missing title for donationId: $donationId ');
//   }
//   final amount = data['amount'] as int?;
//   final date = data['date'] as DateTime?;
//   return Donation(id: id, title: title, amount: amount, date: date)
// }

// Map<String, dynamic> toMap() {
//   return {
//     'id': id,
//     'title': title,
//     'amount': amount,
//     'date': date.toIso8601String(),
//   };
// }

// import 'package:flutter/foundation.dart';

// class Donation {
//   String? id;
//   String? title;
//   double? amount;
//   String? date;

//   Donation({
//     @required this.id,
//     @required this.title,
//     @required this.amount,
//     @required this.date,
//   });

//   Factory fromArray(Map<String, dynamic> array) {
//     id = array['id'] ?? '';
//     title = array['title'] ?? '';
//     amount = array['amount'] ?? '';
//     date = array['date'] ?? '';

//   return new Donation(id: id, title: title, amount: amount, date: date);
//   }

//   Donation.fromArray();
// }

