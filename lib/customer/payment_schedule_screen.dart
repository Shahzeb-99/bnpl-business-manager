import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/payment_schedule_class.dart';
import 'package:flutter/material.dart';

class PaymentScheduleScreen extends StatefulWidget {
  const PaymentScheduleScreen({Key? key, required this.paymentList})
      : super(key: key);

  final List<PaymentSchedule> paymentList;

  @override
  State<PaymentScheduleScreen> createState() => _PaymentScheduleScreenState();
}

class _PaymentScheduleScreenState extends State<PaymentScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Schedule',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: ListView.builder(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: widget.paymentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: const Color(0xFFD6EFF2),
            child: InkWell(
              onLongPress: () async {
                setState(() {
                  widget.paymentList[index].isPaid =
                      !widget.paymentList[index].isPaid;
                });
               await widget.paymentList[index].updateFirestore();
                widget.paymentList[index].updateBalance();
              },
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                    initialDate: DateTime(
                        widget.paymentList[index].date.toDate().year,
                        widget.paymentList[index].date.toDate().month,
                        widget.paymentList[index].date.toDate().day),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(2030),
                    context: context);

                setState(() {
                  widget.paymentList[index].date = Timestamp.fromDate(newDate!);
                });
                widget.paymentList[index].updateFirestore();
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                          '${widget.paymentList[index].date.toDate().day.toString()} - ${widget.paymentList[index].date.toDate().month.toString()} - ${widget.paymentList[index].date.toDate().year.toString()}'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          'Amount : ${widget.paymentList[index].amount.toString()} PKR'),
                    ),
                    widget.paymentList[index].isPaid
                        ? const Expanded(flex: 1, child: Text('Paid'))
                        : const Expanded(flex: 1, child: Text('Not Paid')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
