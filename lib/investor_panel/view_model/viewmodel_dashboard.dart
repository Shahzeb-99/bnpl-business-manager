
import 'package:flutter/material.dart';

import '../../investor_panel/dashboard/dashboard_screen.dart';
import '../../investor_panel/model/dashboard.dart';



class DashboardViewInvestor extends ChangeNotifier {
  DashboardData dashboardData = DashboardData(
      totalAmountPaid: 0,
      totalOutstandingBalance: 0,
      totalCost: 0,
      profit: 0,
      cashAvailable: 0,
      company_profit: 0);

  DashboardData monthlyFinancials = DashboardData(
      totalAmountPaid: 0,
      totalOutstandingBalance: 0,
      totalCost: 0,
      profit: 0,
      cashAvailable: 0,
      company_profit: 0);

  DashboardFilterOptions option = DashboardFilterOptions.all;

  Future<void> getAllFinancials() async {
    await dashboardData.getAllFinancials();
    notifyListeners();
  }

  Future<void> getMonthlyFinancials() async {
  await monthlyFinancials.getMonthlyFinancials(
        isThisMonth: option == DashboardFilterOptions.oneMonth ? true : false);
  await monthlyFinancials.getThisMonthCustomers(
        isThisMonth: option == DashboardFilterOptions.oneMonth ? true : false, update: (){notifyListeners();});

    notifyListeners();
  }
}
