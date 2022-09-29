import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '/model/customers.dart';

class CustomerView extends ChangeNotifier {
  List<Customers> allCustomers = [];
  bool monthSwitch=false;

  void getCustomers() async {
    allCustomers = [];
    final cloud = FirebaseFirestore.instance;
    cloud.settings = const Settings(persistenceEnabled: true);
    await cloud.collection('customers').get().then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var customer in value.docs) {
            Customers newCustomer = Customers(
              name: customer.get('name'),
              image: customer.get('image'),
              outstandingBalance: customer.get('outstanding_balance'),
              paidAmount: customer.get('paid_amount'),
              documentID: customer.id,
            );
            allCustomers.add(newCustomer);
            notifyListeners();
          }
        }
      },
    );
    notifyListeners();
  }

  void getPurchases(int index) async {
   await allCustomers[index].getPurchases();
   notifyListeners();

  }
  void getPaymentSchedule({required int index, required int productIndex}) async {
    await allCustomers[index].purchases[productIndex].getPaymentSchedule(allCustomers[index].documentID);
    notifyListeners();

  }
  void update(){notifyListeners();}
  void toggleSwitch(bool value){monthSwitch=value;notifyListeners();}


}
