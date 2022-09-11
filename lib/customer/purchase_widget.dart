import 'package:ecommerce_bnql/customer/payment_schedule_class.dart';
import 'package:ecommerce_bnql/customer/payment_schedule_screen.dart';
import 'package:flutter/material.dart';


class PurchaseWidget extends StatelessWidget {
  const PurchaseWidget(
      {Key? key,
      required this.paymentList,
      required this.image,
      required this.name,
      required this.outstandingBalance,
      required this.amountPaid})
      : super(key: key);

  final String image;
  final String name;
  final int outstandingBalance;
  final int amountPaid;
  final List<PaymentSchedule> paymentList;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD6EFF2),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentScheduleScreen(paymentList: paymentList)));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(500)),
                height: MediaQuery.of(context).size.height * 0.10,
                width: MediaQuery.of(context).size.height * 0.10,
                child: Image.network(
                  image,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Outstanding Balance : $outstandingBalance PKR'),
                  Text('Amount Paid : $amountPaid PKR'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
