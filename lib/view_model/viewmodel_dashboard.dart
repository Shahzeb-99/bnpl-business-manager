import 'package:ecommerce_bnql/model/dashboard.dart';
import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';

class DashboardView extends ChangeNotifier {
  DashboardData dashboardData = DashboardData(
      totalAmountPaid: 0,
      totalOutstandingBalance: 0,
      totalCost: 0,
      profit: 0,
      cashAvailable: 0,
      expenses: 0);

  DashboardData monthlyFinancials = DashboardData(
      totalAmountPaid: 0,
      totalOutstandingBalance: 0,
      totalCost: 0,
      profit: 0,
      cashAvailable: 0,
      expenses: 0);


  DashboardFilterOptions option = DashboardFilterOptions.all;

  void getAllFinancials() async {
    await dashboardData.getAllFinancials();
    notifyListeners();
  }

  void getMonthlyFinancials() async {
    await monthlyFinancials.getMonthlyFinancials(isThisMonth: option == DashboardFilterOptions.oneMonth?true:false);
    await monthlyFinancials.getThisMonthCustomers();
    notifyListeners();
  }


}
