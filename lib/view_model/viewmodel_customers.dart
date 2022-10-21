import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/dashboard/dashboard_screen.dart';
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

  void getAllCustomersDashboardView() async {
    thisMonthCustomers = [];
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
            thisMonthCustomers.add(newCustomer);
            notifyListeners();
          }
        }
      },
    );
    notifyListeners();
  }

  getThisMonthCustomersOutstanding(
      {required DashboardFilterOptions option}) async {
    thisMonthCustomers = [];
    final cloud = FirebaseFirestore.instance;
    cloud.settings.persistenceEnabled;

    await cloud.collection('customers').get().then((value) async {
      for (var customers in value.docs) {
        num outstandingAmount = 0;

        await customers.reference
            .collection('purchases')
            .get()
            .then((value) async {
          for (var purchase in value.docs) {
            await purchase.reference
                .collection('payment_schedule')
                .where('date',
                    isLessThanOrEqualTo: option != DashboardFilterOptions.all
                        ? DateTime(
                            DateTime.now().year, DateTime.now().month + 1, 0)
                        : DateTime(2100))
                .get()
                .then((value) {
              for (var payment in value.docs) {
                if (!payment.get('isPaid')) {
                  outstandingAmount += payment.get('remainingAmount');
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

    notifyListeners();
  }

  getThisMonthCustomersRecovery(
      {required DashboardFilterOptions option}) async {
    thisMonthCustomers = [];
    final cloud = FirebaseFirestore.instance;
    cloud.settings.persistenceEnabled;

    await cloud.collection('customers').get().then((value) async {
      for (var customers in value.docs) {
        num outstandingBalance = customers.get('outstanding_balance');
        num amountPaid = 0;

        await customers.reference
            .collection('purchases')
            .get()
            .then((value) async {
          for (var purchase in value.docs) {
            await purchase.reference
                .collection('transaction_history')
                .where('date',
                    isLessThanOrEqualTo: option != DashboardFilterOptions.all
                        ? DateTime(
                            DateTime.now().year, DateTime.now().month + 1, 0)
                        : DateTime(2100))
                .get()
                .then((value) {
              for (var transaction in value.docs) {
                amountPaid += transaction.get('amount');
              }
            });
          }
        });
        if (amountPaid > 0) {
          thisMonthCustomers.add(Customers(
            name: customers.get('name'),
            image: customers.get('image'),
            outstandingBalance: outstandingBalance,
            paidAmount: amountPaid,
            documentID: customers.id,
          ));
        }
      }
    });
    notifyListeners();
  }

  void getPurchases(int index) async {
    await allCustomers[index].getPurchases();
    notifyListeners();
  }

  void getAllPurchasesDashboardView(int index) async {
    await thisMonthCustomers[index].getPurchases();
    notifyListeners();
  }

  void getMonthlyPurchasesOutstanding(int index) async {
    await thisMonthCustomers[index].getThisMonthPurchasesOutstanding();
    notifyListeners();
  }

  void getMonthlyPurchasesRecovery(
      int index, DashboardFilterOptions option) async {
    await thisMonthCustomers[index]
        .getThisMonthPurchasesRecovery(option: option);
    notifyListeners();
  }

  void getPaymentSchedule(
      {required int index, required int productIndex}) async {
    await allCustomers[index]
        .purchases[productIndex]
        .getPaymentSchedule(allCustomers[index].documentID);
    notifyListeners();
  }

  void getAllPaymentScheduleDashboardView(
      {required int index, required int productIndex}) async {
    await thisMonthCustomers[index]
        .purchases[productIndex]
        .getPaymentSchedule(thisMonthCustomers[index].documentID);
    notifyListeners();
  }

  void getPaymentScheduleMonthlyOutstanding(
      {required int index, required int productIndex}) async {
    await thisMonthCustomers[index]
        .purchases[productIndex]
        .getPaymentScheduleMonthlyOutstanding(
            thisMonthCustomers[index].documentID);
    notifyListeners();
  }

  void getPaymentScheduleMonthlyRecovery(
      {required int index,
      required int productIndex,
      required DashboardFilterOptions option}) async {
    await thisMonthCustomers[index]
        .purchases[productIndex]
        .getPaymentScheduleMonthlyRecovery(
            thisMonthCustomers[index].documentID, option);
    notifyListeners();
  }

  void getTransactionHistory(
      {required int index, required int productIndex}) async {
    await allCustomers[index]
        .purchases[productIndex]
        .getTransactionHistory(allCustomers[index].documentID);
    notifyListeners();
  }

  void getTransactionHistoryRecovery(
      {required int index,
      required int productIndex,
      required bool isThisMonth}) async {
    await thisMonthCustomers[index]
        .purchases[productIndex]
        .getTransactionHistoryRecovery(
            thisMonthCustomers[index].documentID, isThisMonth);
    notifyListeners();
  }

  void getInstallmentTransactionHistory(
      {required int index,
      required int productIndex,
      required paymentIndex}) async {
    await allCustomers[index]
        .purchases[productIndex]
        .paymentSchedule[paymentIndex]
        .getInstallmentTransactionHistory();
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
