import 'package:ecommerce_bnql/dashboard/amountPaid_button/transaction_widget.dart';
import 'package:ecommerce_bnql/dashboard/dashboard_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/viewmodel_customers.dart';


class TransactionHistoryScreenRecovery extends StatefulWidget {
  const TransactionHistoryScreenRecovery(
      {super.key, required this.index, required this.productIndex});

  final int productIndex;
  final int index;

  @override
  State<TransactionHistoryScreenRecovery> createState() =>
      _TransactionHistoryScreenRecoveryState();
}

class _TransactionHistoryScreenRecoveryState extends State<TransactionHistoryScreenRecovery> {
  @override
  void initState() {
    Provider.of<CustomerView>(context, listen: false).getTransactionHistoryRecovery(
        index: widget.index, productIndex: widget.productIndex, isThisMonth: Provider.of<DashboardView>(context,listen: false).option==DashboardFilterOptions.oneMonth,);
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
        itemCount: Provider
            .of<CustomerView>(context)
            .thisMonthCustomers[widget.index]
            .purchases[widget.productIndex]
            .transactionHistory
            .length,
        itemBuilder: (BuildContext context, int paymentIndex) {
          return TransactionWidgetRecovery(
              index: widget.index,
              productIndex: widget.productIndex,
              paymentIndex: paymentIndex);
        },
      ),
    );
  }
}
