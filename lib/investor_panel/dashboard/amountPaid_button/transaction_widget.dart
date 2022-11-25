
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../investor_panel/view_model/viewmodel_customers.dart';



class TransactionWidgetRecovery extends StatefulWidget {
  const TransactionWidgetRecovery({Key? key,
    required this.index,
    required this.productIndex,
    required this.paymentIndex})
      : super(key: key);

  final int index;
  final int productIndex;
  final int paymentIndex;

  @override
  State<TransactionWidgetRecovery> createState() => _TransactionWidgetRecoveryState();
}

class _TransactionWidgetRecoveryState extends State<TransactionWidgetRecovery> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color:Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                  '${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .thisMonthCustomers[widget.index].purchases[widget
                      .productIndex].transactionHistory[widget.paymentIndex].date
                      .toDate()
                      .day
                      .toString()} - ${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .thisMonthCustomers[widget.index].purchases[widget
                      .productIndex].transactionHistory[widget.paymentIndex].date
                      .toDate()
                      .month
                      .toString()} - ${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .thisMonthCustomers[widget.index].purchases[widget
                      .productIndex].transactionHistory[widget.paymentIndex].date
                      .toDate()
                      .year
                      .toString()}'),
            ),
            Expanded(
              flex: 4,
              child: Text(
                  'Amount : ${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .thisMonthCustomers[widget.index].purchases[widget
                      .productIndex].transactionHistory[widget.paymentIndex]
                      .amount.toString()} PKR'),
            ),

          ],
        ),
      ),
    );
  }

}
