// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/viewmodel_customers.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget(
      {Key? key,
      required this.index,
      required this.productIndex,
      required this.paymentIndex})
      : super(key: key);

  final int index;
  final int productIndex;
  final int paymentIndex;

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2C3F),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                  '${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].transactionHistory[widget.paymentIndex].date.toDate().day.toString()} - ${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].transactionHistory[widget.paymentIndex].date.toDate().month.toString()} - ${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].transactionHistory[widget.paymentIndex].date.toDate().year.toString()}'),
            ),
            Expanded(
              flex: 4,
              child: Text(
                  'Amount : ${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].transactionHistory[widget.paymentIndex].amount.toString()} PKR'),
            ),
          ],
        ),
      ),
    );
  }
}
