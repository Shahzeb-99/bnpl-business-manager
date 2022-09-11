import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentSchedule {
  int amount;
  Timestamp date;
  bool isPaid;
  DocumentReference purchaseReference;
  String paymentReference;

  PaymentSchedule({required this.paymentReference,required this.purchaseReference,required this.amount, required this.date, required this.isPaid});

  void updateFirestore(){
    purchaseReference.collection('payment_schedule').doc(paymentReference).update(
        {'date': date});
  }

}