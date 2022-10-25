
import 'package:ecommerce_bnql/company_panel/dashboard/reusableTransactionWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/viewmodel_dashboard.dart';


class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});





  @override
  State<ExpensesScreen> createState() =>
      _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    Provider.of<DashboardView>(context, listen: false).getExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: ListView.builder(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: Provider.of<DashboardView>(context).dashboardData.expensesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ReusableTransactionWidget(
              index: index,
              );
        },
      ),
    );
  }
}
