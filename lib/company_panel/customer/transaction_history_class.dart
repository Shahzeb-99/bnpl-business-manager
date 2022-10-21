import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistory{

  int amount;
  Timestamp date;

  TransactionHistory({required this.amount,required this.date});


}
