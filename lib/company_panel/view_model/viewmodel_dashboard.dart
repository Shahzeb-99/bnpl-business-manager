
import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../model/dashboard.dart';

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

  Future<void> getAllFinancials() async {
    await dashboardData.getAllFinancials();
    notifyListeners();
  }

  Future<void> getMonthlyFinancials() async {
    await monthlyFinancials.getMonthlyFinancials(
        isThisMonth: option == DashboardFilterOptions.oneMonth ? true : false);
    await monthlyFinancials.getThisMonthCustomers(
        isThisMonth: option == DashboardFilterOptions.oneMonth ? true : false);

    notifyListeners();
  }

  Future<void> getExpenses() async {

   await dashboardData.getAllExpenses();
   notifyListeners();

  }
  Future<void> getTransactions() async {

    await dashboardData.getAllTransactions();
    notifyListeners();

  }
}
