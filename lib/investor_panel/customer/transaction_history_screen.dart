
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../investor_panel/customer/TransactionWidget.dart';
import '../../investor_panel/view_model/viewmodel_customers.dart';




class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen(
      {super.key, required this.index, required this.productIndex});

  final int productIndex;
  final int index;

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    Provider.of<CustomerViewInvestor>(context, listen: false).getTransactionHistory(
        index: widget.index, productIndex: widget.productIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title:   const Text('Transaction History',style: TextStyle(color: Color(0xFFE56E14),),),
      ),
      body: ListView.builder(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: Provider.of<CustomerViewInvestor>(context)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .transactionHistory
            .length,
        itemBuilder: (BuildContext context, int paymentIndex) {
          return TransactionWidget(
              index: widget.index,
              productIndex: widget.productIndex,
              paymentIndex: paymentIndex);
        },
      ),
    );
  }
}
