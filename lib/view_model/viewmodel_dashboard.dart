import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/model/dashboard.dart';
import 'package:flutter/material.dart';

class DashboardView extends ChangeNotifier {
  DashboardData dashboardData = DashboardData(
      totalAmountPaid: 0, totalOutstandingBalance: 0, totalCost: 0, profit: 0,cashAvailable: 0);

  getFinancials() {
    dashboardData.totalCost=0;
    dashboardData.totalOutstandingBalance=0;
    dashboardData.totalAmountPaid=0;

    final cloud = FirebaseFirestore.instance;

    cloud.collection('financials').get().then((value) {
      if(value.docs.isNotEmpty){

        dashboardData.totalOutstandingBalance=value.docs[0].get('outstanding_balance');
        dashboardData.totalAmountPaid=value.docs[0].get('amount_paid');
        dashboardData.totalCost=value.docs[0].get('total_cost');
        dashboardData.cashAvailable=value.docs[0].get('cash_available');
        dashboardData.profit=(dashboardData.totalOutstandingBalance+dashboardData.totalAmountPaid)-dashboardData.totalCost;
        notifyListeners();

      }
    });


  }
}
