// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel/customer/payment_transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../investor_panel/view_model/viewmodel_customers.dart';



class PaymentScheduleWidget extends StatefulWidget {
  const PaymentScheduleWidget({Key? key,
    required this.index,
    required this.productIndex,
    required this.paymentIndex})
      : super(key: key);

  final int index;
  final int productIndex;
  final int paymentIndex;

  @override
  State<PaymentScheduleWidget> createState() => _PaymentScheduleWidgetState();
}

class _PaymentScheduleWidgetState extends State<PaymentScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2C3F),
      child: InkWell(

        onLongPress: () async {
          DateTime? newDate = await showDatePicker(
              initialDate: DateTime(
                  Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .allCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .year,
                  Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .allCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .month,
                  Provider
                      .of<CustomerViewInvestor>(context, listen: false)
                      .allCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .day),
              firstDate: DateTime(DateTime
                  .now()
                  .year),
              lastDate: DateTime(2030),
              context: context);

          setState(() {
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .date = Timestamp.fromDate(newDate!);
          });
          Provider
              .of<CustomerViewInvestor>(context, listen: false)
              .allCustomers[widget.index]
              .purchases[widget.productIndex]
              .paymentSchedule[widget.paymentIndex]
              .updateFirestore();
        }, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            PaymentTransactionHistoryScreen(index: widget.index,
              productIndex: widget.productIndex,
              paymentIndex: widget.paymentIndex,)));
      },
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
                        .productIndex].paymentSchedule[widget.paymentIndex].date
                        .toDate()
                        .day
                        .toString()} - ${Provider
                        .of<CustomerViewInvestor>(context, listen: false)
                        .allCustomers[widget.index].purchases[widget
                        .productIndex].paymentSchedule[widget.paymentIndex].date
                        .toDate()
                        .month
                        .toString()} - ${Provider
                        .of<CustomerViewInvestor>(context, listen: false)
                        .allCustomers[widget.index].purchases[widget
                        .productIndex].paymentSchedule[widget.paymentIndex].date
                        .toDate()
                        .year
                        .toString()}'),
              ),
              Expanded(
                flex: 4,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Amount : ${Provider
                            .of<CustomerViewInvestor>(context, listen: false)
                            .allCustomers[widget.index].purchases[widget
                            .productIndex].paymentSchedule[widget.paymentIndex]
                            .amount.toString()} PKR'),
                    Text(
                        'Remaining : ${Provider
                            .of<CustomerViewInvestor>(context, listen: false)
                            .allCustomers[widget.index].purchases[widget
                            .productIndex].paymentSchedule[widget.paymentIndex]
                            .remainingAmount.toString()} PKR'),
                  ],
                ),
              ),
              Provider
                  .of<CustomerViewInvestor>(context, listen: false)
                  .allCustomers[widget.index]
                  .purchases[widget.productIndex]
                  .paymentSchedule[widget.paymentIndex]
                  .isPaid
                  ? const Expanded(flex: 1, child: Text('Paid'))
                  : const Expanded(flex: 1, child: Text('Not Paid')),
            ],
          ),
        ),
      ),
    );
  }

  update() {
    Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .outstandingBalance =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .outstandingBalance -
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .outstandingBalance =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .outstandingBalance +
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
    Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .amountPaid +
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .amountPaid -
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;

    Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .outstandingBalance =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .outstandingBalance -
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .outstandingBalance =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .outstandingBalance +
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
    Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .paidAmount =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .paidAmount +
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerViewInvestor>(context, listen: false)
        .allCustomers[widget.index]
        .paidAmount =
        Provider
            .of<CustomerViewInvestor>(context, listen: false)
            .allCustomers[widget.index]
            .paidAmount -
            Provider
                .of<CustomerViewInvestor>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
  }
}
