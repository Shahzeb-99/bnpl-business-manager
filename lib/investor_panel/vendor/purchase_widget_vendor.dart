import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bnql/investor_panel/customer/payment_schedule_class.dart';

import 'package:flutter/material.dart';

class PurchaseWidgetVendor extends StatefulWidget {
  const PurchaseWidgetVendor({
    Key? key,
    required this.image,
    required this.name,
    required this.outstandingBalance,
    required this.amountPaid,
  }) : super(key: key);

  final String image;
  final String name;
  final num outstandingBalance;
  final num amountPaid;

  @override
  State<PurchaseWidgetVendor> createState() => _PurchaseWidgetVendorState();
}

class _PurchaseWidgetVendorState extends State<PurchaseWidgetVendor> {
  List<PaymentSchedule> paymentList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2C3F),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(500)),
                height: MediaQuery.of(context).size.height * 0.10,
                width: MediaQuery.of(context).size.height * 0.10,
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: widget.image,
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
