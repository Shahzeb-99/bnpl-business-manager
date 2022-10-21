// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/viewmodel_customers.dart';

class PaymentScheduleWidgetMonthly extends StatefulWidget {
  const PaymentScheduleWidgetMonthly({Key? key,
    required this.index,
    required this.productIndex,
    required this.paymentIndex})
      : super(key: key);

  final int index;
  final int productIndex;
  final int paymentIndex;

  @override
  State<PaymentScheduleWidgetMonthly> createState() =>
      _PaymentScheduleWidgetMonthlyState();
}

class _PaymentScheduleWidgetMonthlyState
    extends State<PaymentScheduleWidgetMonthly> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2C3F),
      child: InkWell(

        onTap: () async {
          DateTime? newDate = await showDatePicker(
              initialDate: DateTime(
                  Provider
                      .of<CustomerView>(context, listen: false)
                      .thisMonthCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .year,
                  Provider
                      .of<CustomerView>(context, listen: false)
                      .thisMonthCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .month,
                  Provider
                      .of<CustomerView>(context, listen: false)
                      .thisMonthCustomers[widget.index]
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
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .date = Timestamp.fromDate(newDate!);
          });
          Provider
              .of<CustomerView>(context, listen: false)
              .thisMonthCustomers[widget.index]
              .purchases[widget.productIndex]
              .paymentSchedule[widget.paymentIndex]
              .updateFirestore();
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
                        .of<CustomerView>(context, listen: false)
                        .thisMonthCustomers[widget.index].purchases[widget
                        .productIndex].paymentSchedule[widget.paymentIndex].date
                        .toDate()
                        .day
                        .toString()} - ${Provider
                        .of<CustomerView>(context, listen: false)
                        .thisMonthCustomers[widget.index].purchases[widget
                        .productIndex].paymentSchedule[widget.paymentIndex].date
                        .toDate()
                        .month
                        .toString()} - ${Provider
                        .of<CustomerView>(context, listen: false)
                        .thisMonthCustomers[widget.index].purchases[widget
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
                            .of<CustomerView>(context, listen: false)
                            .thisMonthCustomers[widget.index].purchases[widget
                            .productIndex].paymentSchedule[widget.paymentIndex]
                            .amount.toString()} PKR'),
                    Text(
                        'Remaining : ${Provider
                            .of<CustomerView>(context, listen: false)
                            .thisMonthCustomers[widget.index].purchases[widget
                            .productIndex].paymentSchedule[widget.paymentIndex]
                            .remainingAmount.toString()} PKR'),
                  ],
                ),
              ),
              Provider
                  .of<CustomerView>(context, listen: false)
                  .thisMonthCustomers[widget.index]
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
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .outstandingBalance =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .purchases[widget.productIndex]
            .outstandingBalance -
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .outstandingBalance =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .purchases[widget.productIndex]
            .outstandingBalance +
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
    Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .purchases[widget.productIndex]
            .amountPaid +
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .purchases[widget.productIndex]
            .amountPaid -
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;

    Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .outstandingBalance =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .outstandingBalance -
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .outstandingBalance =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .outstandingBalance +
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
    Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .paidAmount =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .paidAmount +
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider
        .of<CustomerView>(context, listen: false)
        .thisMonthCustomers[widget.index]
        .paidAmount =
        Provider
            .of<CustomerView>(context, listen: false)
            .thisMonthCustomers[widget.index]
            .paidAmount -
            Provider
                .of<CustomerView>(context, listen: false)
                .thisMonthCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
  }
}
