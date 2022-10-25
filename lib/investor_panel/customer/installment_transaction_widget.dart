
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../investor_panel/view_model/viewmodel_customers.dart';



class InstallmentTransactionWidget extends StatefulWidget {
  const InstallmentTransactionWidget({Key? key,
    required this.index,
    required this.productIndex,
    required this.paymentIndex, required this.transactionIndex})
      : super(key: key);

  final int index;
  final int productIndex;
  final int paymentIndex;
  final int transactionIndex;

  @override
  State<InstallmentTransactionWidget> createState() => _InstallmentTransactionWidgetState();
}

class _InstallmentTransactionWidgetState extends State<InstallmentTransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color:const Color(0xFF2D2C3F),
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
                      .allCustomers[widget.index].purchases[widget
                      .productIndex].paymentSchedule[widget.paymentIndex].transactionHistory[widget.transactionIndex].date
                      .toDate()
                      .day
                      .toString()} - ${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .allCustomers[widget.index].purchases[widget
                      .productIndex].paymentSchedule[widget.paymentIndex].transactionHistory[widget.transactionIndex].date
                      .toDate()
                      .month
                      .toString()} - ${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .allCustomers[widget.index].purchases[widget
                      .productIndex].paymentSchedule[widget.paymentIndex].transactionHistory[widget.transactionIndex].date
                      .toDate()
                      .year
                      .toString()}'),
            ),
            Expanded(
              flex: 4,
              child: Text(
                  'Amount : ${Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .allCustomers[widget.index].purchases[widget
                      .productIndex].paymentSchedule[widget.paymentIndex].transactionHistory[widget.transactionIndex]
                      .amount.toString()} PKR'),
            ),

          ],
        ),
      ),
    );
  }

}