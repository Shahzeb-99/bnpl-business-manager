import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:flutter/foundation.dart';
import '/model/customers.dart';

class CustomerView extends ChangeNotifier {
  List<Customers> allCustomers = [];
  List<Customers> thisMonthCustomers = [];
  bool monthSwitch = false;
  CustomerFilterOptions option = CustomerFilterOptions.all;

  void getCustomers() async {
    allCustomers = [];
    final cloud = FirebaseFirestore.instance;
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

  getThisMonthCustomers() async {
    thisMonthCustomers=[];
    final cloud = FirebaseFirestore.instance;
    cloud.settings.persistenceEnabled;
    print('base');
    await cloud.collection('customers').get().then((value) async {
      for (var customers in value.docs) {
        num outstandingAmount = 0;
        print('loop1');
        await customers.reference.collection('purchases').get().then((value) async {
          for (var purchase in value.docs) {
            print('loop2');
           await purchase.reference
                .collection('payment_schedule')
                .where('date',
                    isLessThanOrEqualTo: DateTime(
                        DateTime.now().year, DateTime.now().month + 1, 0))
                .get()
                .then((value) {
              print(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
              for (var payment in value.docs) {
                if (!payment.get('isPaid')) {
                  outstandingAmount += payment.get('amount');
                }
              }
            });
          }
        });
        if (outstandingAmount > 0) {
          thisMonthCustomers.add(Customers(
            name: customers.get('name'),
            image: customers.get('image'),
            outstandingBalance: outstandingAmount,
            paidAmount: customers.get('paid_amount'),
            documentID: customers.id,
          ));
        }
      }
    });

    print(thisMonthCustomers[0].name);
    print(thisMonthCustomers[0].outstandingBalance);
    notifyListeners();
  }

  void getPurchases(int index) async {
    await allCustomers[index].getPurchases();
    notifyListeners();
  }
  void getMonthlyPurchases(int index) async {
    await thisMonthCustomers[index].getThisMonthPurchases();
    notifyListeners();
  }

  void getPaymentSchedule(
      {required int index, required int productIndex}) async {
    await allCustomers[index]
        .purchases[productIndex]
        .getPaymentSchedule(allCustomers[index].documentID);
    notifyListeners();
  }

  void getPaymentScheduleMonthly(
      {required int index, required int productIndex}) async {
    await thisMonthCustomers[index]
        .purchases[productIndex]
        .getPaymentScheduleMonthly(thisMonthCustomers[index].documentID);
    notifyListeners();
  }

  void getTransactionHistory(
      {required int index, required int productIndex}) async {
    await allCustomers[index]
        .purchases[productIndex]
        .getTransactionHistory(allCustomers[index].documentID);
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void toggleSwitch(bool value) {
    monthSwitch = value;
    notifyListeners();
  }
}
