import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '/model/customers.dart';

class CustomerView extends ChangeNotifier {
  List<Customers> allCustomers = [];

  void getCustomers() async {
    final cloud = FirebaseFirestore.instance;
    await cloud.collection('customers').get().then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var customer in value.docs) {
            Customers newCustomer = Customers(name:
              customer.get('name'),image:
              customer.get('image'),outstanding_balance:
              customer.get('outstanding_balance'),paid_amount:
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
