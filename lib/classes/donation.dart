import 'package:flutter/foundation.dart';

class Donation {
  final String? id;
  final String? title;
  final double? amount;
  final String? date;

  Donation({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });
}
