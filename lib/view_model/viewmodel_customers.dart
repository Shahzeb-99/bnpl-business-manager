import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '/model/customers.dart';

class CustomerView extends ChangeNotifier {
  List<Customers> allCustomers = [];

  void getCustomers() async {
    allCustomers = [];
    final cloud = FirebaseFirestore.instance;
    await cloud.collection('customers').get().then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var customer in value.docs) {
            Customers newCustomer = Customers(name:
              customer.get('name'),image:
              customer.get('image'),outstandingBalance:
              customer.get('outstanding_balance'),paidAmount:
              customer.get('paid_amount'), documentID: customer.id,
            );
            allCustomers.add(newCustomer);
            notifyListeners();
          }
        }
      },
    );
    notifyListeners();
  }
}
