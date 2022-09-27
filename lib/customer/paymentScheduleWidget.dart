import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScheduleWidget extends StatefulWidget {
  const PaymentScheduleWidget(
      {Key? key,
      required this.index,
      required this.productIndex,
      required this.paymentIndex})
      : super(key: key);

  final index;
  final productIndex;
  final paymentIndex;

  @override
  State<PaymentScheduleWidget> createState() => _PaymentScheduleWidgetState();
}

class _PaymentScheduleWidgetState extends State<PaymentScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD6EFF2),
      child: InkWell(
        onLongPress: () {
          setState(() {
            Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .togglePayment();
            update();
          });
        },
        onTap: () async {
          DateTime? newDate = await showDatePicker(
              initialDate: DateTime(
                  Provider.of<CustomerView>(context, listen: false)
                      .allCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .year,
                  Provider.of<CustomerView>(context, listen: false)
                      .allCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .month,
                  Provider.of<CustomerView>(context, listen: false)
                      .allCustomers[widget.index]
                      .purchases[widget.productIndex]
                      .paymentSchedule[widget.paymentIndex]
                      .date
                      .toDate()
                      .day),
              firstDate: DateTime(DateTime.now().year),
              lastDate: DateTime(2030),
              context: context);

          setState(() {
            Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .date = Timestamp.fromDate(newDate!);
          });
          Provider.of<CustomerView>(context, listen: false)
              .allCustomers[widget.index]
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
                    '${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].paymentSchedule[widget.paymentIndex].date.toDate().day.toString()} - ${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].paymentSchedule[widget.paymentIndex].date.toDate().month.toString()} - ${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].paymentSchedule[widget.paymentIndex].date.toDate().year.toString()}'),
              ),
              Expanded(
                flex: 2,
                child: Text(
                    'Amount : ${Provider.of<CustomerView>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].paymentSchedule[widget.paymentIndex].amount.toString()} PKR'),
              ),
              Provider.of<CustomerView>(context, listen: false)
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
    Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .paymentSchedule[widget.paymentIndex]
            .isPaid
        ? Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .outstandingBalance =
            Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .outstandingBalance -
                Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .paymentSchedule[widget.paymentIndex]
                    .amount
        : Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .outstandingBalance =
            Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .outstandingBalance +
                Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .paymentSchedule[widget.paymentIndex]
                    .amount;
    Provider.of<CustomerView>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider.of<CustomerView>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid =
        Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .amountPaid +
            Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider.of<CustomerView>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .amountPaid =
        Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .amountPaid -
            Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;

    Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .purchases[widget.productIndex]
            .paymentSchedule[widget.paymentIndex]
            .isPaid
        ? Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .outstandingBalance =
            Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .outstandingBalance -
                Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .paymentSchedule[widget.paymentIndex]
                    .amount
        : Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .outstandingBalance =
            Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .outstandingBalance +
                Provider.of<CustomerView>(context, listen: false)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .paymentSchedule[widget.paymentIndex]
                    .amount;
    Provider.of<CustomerView>(context, listen: false)
        .allCustomers[widget.index]
        .purchases[widget.productIndex]
        .paymentSchedule[widget.paymentIndex]
        .isPaid
        ? Provider.of<CustomerView>(context, listen: false)
        .allCustomers[widget.index]
        .paidAmount =
        Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .paidAmount +
            Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount
        : Provider.of<CustomerView>(context, listen: false)
        .allCustomers[widget.index]
        .paidAmount =
        Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .paidAmount -
            Provider.of<CustomerView>(context, listen: false)
                .allCustomers[widget.index]
                .purchases[widget.productIndex]
                .paymentSchedule[widget.paymentIndex]
                .amount;
  }
}
