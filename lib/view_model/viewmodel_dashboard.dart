import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/model/dashboard.dart';
import 'package:flutter/material.dart';

class DashboardView extends ChangeNotifier {
  DashboardData dashboardData = DashboardData(
      totalAmountPaid: 0, totalOutstandingBalance: 0, totalCost: 0);

  getFinancials() {
    dashboardData.totalOutstandingBalance = 0;
    dashboardData.totalAmountPaid = 0;
    dashboardData.totalCost = 0;
    final cloud = FirebaseFirestore.instance;

    cloud.collection('customers').get().then(
      (value) async {
        for (var customers in value.docs) {
          await customers.reference.collection('purchases').get().then((value) {
            for (var purchases in value.docs) {
              DocumentReference product = purchases.get('product');
              product.get().then((value) {
                DocumentReference vendorProduct = value.get('reference');
                vendorProduct.get().then((value) {
                  final int cost = value.get('price');
                  dashboardData.totalCost = dashboardData.totalCost + cost;
                  notifyListeners();
                });
              });
            }
          });

          final outstandingBalance = customers.get('outstanding_balance');

          final amountPaid = customers.get('paid_amount');
          dashboardData.totalOutstandingBalance =
              dashboardData.totalOutstandingBalance + outstandingBalance as int;
          dashboardData.totalAmountPaid =
              dashboardData.totalAmountPaid + amountPaid as int;
        }
        notifyListeners();
      },
    );
  }
}
