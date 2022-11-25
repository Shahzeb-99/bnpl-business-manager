import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_vendors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../investor_panel/vendor/resuable_transaction_widget.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key, required this.investorIndex});

  final int investorIndex;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    Provider.of<VendorViewInvestor>(context, listen: false).getTransactions(widget.investorIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text('Transaction History',style: TextStyle(color: Colors.purple.shade900),),
      ),
      body: ListView.builder(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: Provider.of<VendorViewInvestor>(context)
            .allVendors[widget.investorIndex]
            .expensesList
            .length,
        itemBuilder: (BuildContext context, int index) {
          return ReusableTransactionWidget(
            index: index, investorIndex: widget.investorIndex,
          );
        },
      ),
    );
  }
}
