import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/model/dashboard.dart';
import 'package:flutter/material.dart';

class DashboardView extends ChangeNotifier{

  DashboardData dashboardData = DashboardData(totalAmountPaid: 0, totalOutstandingBalance: 0);

  getFinancials() {
    dashboardData.totalOutstandingBalance=0;
    dashboardData.totalAmountPaid=0;
    final cloud = FirebaseFirestore.instance;

    cloud
        .collection('customers')
        .get()
        .then(
          (value) {

          for (var customers in value.docs) {
          final outstandingBalance = customers.get('outstanding_balance');
          print(outstandingBalance);
          final amountPaid = customers.get('paid_amount');
          dashboardData.totalOutstandingBalance=dashboardData.totalOutstandingBalance+outstandingBalance as int;
          dashboardData.totalAmountPaid=dashboardData.totalAmountPaid+amountPaid as int;

          }
          notifyListeners();

      },
    );
  }

}