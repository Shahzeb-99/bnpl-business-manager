import 'package:ecommerce_bnql/customer/payment_schedule_class.dart';
import 'package:ecommerce_bnql/customer/payment_schedule_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseWidget extends StatefulWidget {
  const PurchaseWidget(
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
  State<PurchaseWidget> createState() => _PurchaseWidgetState();
}

class _PurchaseWidgetState extends State<PurchaseWidget> {
  List<PaymentSchedule> paymentList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD6EFF2),
      child: InkWell(
        onTap: ()   {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScheduleScreen(
                paymentList: paymentList,
                productIndex: widget.productIndex,
                index: widget.index,
              ),
            ),
          ).whenComplete(() =>  Provider.of<CustomerView>(context, listen: false).update());
       
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
