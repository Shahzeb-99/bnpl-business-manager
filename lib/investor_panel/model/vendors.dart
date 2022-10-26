import 'package:cloud_firestore/cloud_firestore.dart';

class Investors {
  Investors(
      {required this.investorReference,
      required this.openingBalance,
      required this.name,
      required this.currentBalance});

  final String name;
  num currentBalance;
  num openingBalance;
  DocumentReference investorReference;
}
