import 'package:cloud_firestore/cloud_firestore.dart';

import '/customer/payment_schedule_class.dart';

class Purchase {
  String customerID;
  DocumentReference documentReferencePurchase;
  Timestamp purchaseDate;
  var purchaseAmount;
  String vendorName;
  var sellingAmount;
  String? profitPercentage;
  var totalProfit;
  String productName;
  String productImage;
  var outstandingBalance;
  var amountPaid;
  List<PaymentSchedule> paymentSchedule = [];

  Purchase(
      {required this.customerID,
      required this.documentReferencePurchase,
      required this.vendorName,
      required this.outstandingBalance,
      required this.amountPaid,
      required this.productName,
      required this.productImage,
      this.profitPercentage,
      required this.purchaseAmount,
      required this.sellingAmount,
      this.totalProfit,
      required this.purchaseDate});

  Future<void> getPaymentSchedule(String customerDocID) async {
    paymentSchedule = [];
    await documentReferencePurchase
        .collection('payment_schedule')
        .orderBy('date', descending: false)
        .get()
        .then((value) {
      for (var payment in value.docs) {
        var amount = payment.get('amount');
        Timestamp date = payment.get('date');
        bool isPaid = payment.get('isPaid');

        paymentSchedule.add(PaymentSchedule(
            remainingAmount: payment.get('remainingAmount'),
            amount: amount,
            isPaid: isPaid,
            date: date,
            paymentReference: payment.id,
            purchaseReference: documentReferencePurchase,
            customerdocID: customerDocID));
      }
    });
  }

  updateCustomTransaction({required int amount}) async {
    final cloud = FirebaseFirestore.instance;

    await cloud.collection('customers').doc(customerID).update({
      'outstanding_balance': FieldValue.increment(-amount),
      'paid_amount': FieldValue.increment(amount),
    });

    await documentReferencePurchase.update({
      'outstanding_balance': FieldValue.increment(-amount),
      'paid_amount': FieldValue.increment(amount),
    });
    cloud.collection('financials').doc('finance').update({
      'amount_paid': FieldValue.increment(amount),
      'outstanding_balance': FieldValue.increment(-amount),
      'cash_available': FieldValue.increment(amount),
    });
  }
}
