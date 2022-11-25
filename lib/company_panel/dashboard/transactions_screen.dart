
import 'package:ecommerce_bnql/company_panel/dashboard/reusableTransactionWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/viewmodel_dashboard.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});





  @override
  State<TransactionScreen> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    Provider.of<DashboardView>(context, listen: false).getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Transaction History',style: TextStyle(color: Color(0xFFE56E14),),),
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
