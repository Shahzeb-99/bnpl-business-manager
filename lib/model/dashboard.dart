class DashboardData {
  int totalOutstandingBalance;
  int totalAmountPaid;
  int totalCost;
  int profit;
  int cashAvailable;
  int expenses;

  DashboardData(
      {required this.expenses,
      required this.cashAvailable,
      required this.profit,
      required this.totalAmountPaid,
      required this.totalOutstandingBalance,
      required this.totalCost});
}
