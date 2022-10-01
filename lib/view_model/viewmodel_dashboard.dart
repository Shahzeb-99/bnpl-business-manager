import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/model/dashboard.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';

class DashboardView extends ChangeNotifier {
  DashboardData dashboardData = DashboardData(
      totalAmountPaid: 0,
      totalOutstandingBalance: 0,
      totalCost: 0,
      profit: 0,
      cashAvailable: 0);

  var outstandingBalance;
  var amount_paid;
  var total_cost;
  DashboardFilterOptions option = DashboardFilterOptions.all;

  getFinancials() {
    dashboardData.totalCost = 0;
    dashboardData.totalOutstandingBalance = 0;
    dashboardData.totalAmountPaid = 0;

    final cloud = FirebaseFirestore.instance;

    cloud.collection('financials').get().then((value) {
      if (value.docs.isNotEmpty) {
        dashboardData.totalOutstandingBalance =
            value.docs[0].get('outstanding_balance');
        dashboardData.totalAmountPaid = value.docs[0].get('amount_paid');
        dashboardData.totalCost = value.docs[0].get('total_cost');
        dashboardData.cashAvailable = value.docs[0].get('cash_available');
        dashboardData.profit = (dashboardData.totalOutstandingBalance +
                dashboardData.totalAmountPaid) -
            dashboardData.totalCost;
        notifyListeners();
      }
    });
  }

  getMonthlyFinancials() async {
    outstandingBalance = 0;
    amount_paid = 0;
    total_cost = 0;
    final cloud = FirebaseFirestore.instance;

    await cloud.collection('customers').get().then(
      (value) async {
        for (var customer in value.docs) {
          await customer.reference
              .collection('purchases')
              .where('purchaseDate',
                  isGreaterThan: Timestamp.fromDate(
                      DateTime.now().subtract(option==DashboardFilterOptions.oneMonth?Duration(days: 30):Duration(days: 180))))
              .get()
              .then((value) async {
            for (var purchase in value.docs) {
              print(purchase.get('purchaseDate'));
              outstandingBalance += purchase.get('outstanding_balance');
              amount_paid += purchase.get('paid_amount');
              DocumentReference product = purchase.get('product');
              await product.get().then(
                (value) {
                  DocumentReference venderProductRef = value.get('reference');
                  venderProductRef.get().then(
                    (value) {
                      total_cost += value.get('price');
                    },
                  );
                },
              );
              print(outstandingBalance);
            }
          });
        }
      },
    );
    print('object');
    notifyListeners();
  }
}
