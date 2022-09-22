import 'package:cloud_firestore/cloud_firestore.dart';

class Customers {
  Customers(
      {required this.name,
      required this.image,
      required this.outstandingBalance,
      required this.paidAmount,
      required this.documentID});

  final String name;
  final String image;
  final outstandingBalance;
  final paidAmount;
  final String documentID;
 // List<PaymentSchedule> listOfPayment

  deleteCustomer() async {
    int cost = 0;
    final cloud = FirebaseFirestore.instance;
    await cloud
        .collection('customers')
        .doc(documentID)
        .collection('purchases')
        .get()
        .then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var product in value.docs) {
            DocumentReference productRef = product.get('product');
           await productRef.get().then(
              (value) async {
                DocumentReference vendorReference = value.get('reference');
               await vendorReference.get().then(
                  (value) {
                    final int cost1 =  value.get('price');
                    cost = cost + cost1;
                  },
                );
                vendorReference.delete();
              },
            );
            productRef.delete();
          }
        }
      },
    );
    cloud.collection('customers').doc(documentID).delete();
    cloud.collection('financials').doc('finance').update(
      {
        'amount_paid': FieldValue.increment(-paidAmount),
        'outstanding_balance': FieldValue.increment(-outstandingBalance),
        'total_cost': FieldValue.increment(-cost),
      },
    );
  }
}
