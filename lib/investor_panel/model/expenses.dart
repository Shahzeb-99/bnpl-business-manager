import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses{

  Expenses({required this.amount,required this.date, required this.description});

  num amount;
  Timestamp date;
  String description;


}