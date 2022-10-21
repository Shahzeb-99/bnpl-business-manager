import 'package:ecommerce_bnql/company_panel/dashboard/outstandingAmount_button/payment_schedule_screen_monthly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../customer/payment_schedule_class.dart';
import '../../view_model/viewmodel_customers.dart';

class PurchaseWidgetMonthlyOutstanding extends StatefulWidget {
  const PurchaseWidgetMonthlyOutstanding(
      {Key? key,
        required this.image,
        required this.name,
        required this.outstandingBalance,
        required this.amountPaid,
        required this.productIndex,
        required this.index})
      : super(key: key);

  final int productIndex;
  final int index;
  final String image;
  final String name;
  final int outstandingBalance;
  final int amountPaid;

  @override
  State<PurchaseWidgetMonthlyOutstanding> createState() => _PurchaseWidgetMonthlyOutstandingState();
}

class _PurchaseWidgetMonthlyOutstandingState extends State<PurchaseWidgetMonthlyOutstanding> {
  List<PaymentSchedule> paymentList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      color:const Color(0xFF2D2C3F),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScheduleScreenMonthlyOutstanding(
                paymentList: paymentList,
                productIndex: widget.productIndex,
                index: widget.index,
              ),
            ),
          ).whenComplete(
                  () {
                Provider.of<CustomerView>(context, listen: false).update();
                setState(() {

                });
              });
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
                  widget.image,
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
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Outstanding Balance : ${widget.outstandingBalance} PKR'),
                  Text('Amount Paid : ${widget.amountPaid} PKR'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
