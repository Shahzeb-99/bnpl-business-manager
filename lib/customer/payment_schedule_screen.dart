import 'package:flutter/material.dart';
import 'package:ecommerce_bnql/customer/customer_screen.dart';

class PaymentScheduleScreen extends StatelessWidget {
  const PaymentScheduleScreen({Key? key, required this.paymentList}) : super(key: key);

  final List<PaymentSchedule> paymentList;

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
        itemCount: paymentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: const Color(0xFFD6EFF2),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2,
                    child: Text(
                        '${paymentList[index].date.toDate().day.toString()} - ${paymentList[index].date.toDate().month.toString()} - ${paymentList[index].date.toDate().year.toString()}'),
                  ),
                  Expanded(flex:2,child: Text('Amount : ${paymentList[index].amount.toString()} PKR')),
                  paymentList[index].isPaid ? const Expanded(flex:1,child: Text('Paid')) : const Expanded(flex:1,child: Text('Not Paid')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
