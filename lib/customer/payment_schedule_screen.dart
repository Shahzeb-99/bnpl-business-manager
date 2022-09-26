import 'package:ecommerce_bnql/customer/paymentScheduleWidget.dart';
import 'package:ecommerce_bnql/customer/payment_schedule_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/viewmodel_customers.dart';

class PaymentScheduleScreen extends StatefulWidget {
  const PaymentScheduleScreen(
      {Key? key, required this.paymentList, required this.productIndex,required this.index})
      : super(key: key);

  final List<PaymentSchedule> paymentList;
  final productIndex;
  final index;

  @override
  State<PaymentScheduleScreen> createState() => _PaymentScheduleScreenState();
}

class _PaymentScheduleScreenState extends State<PaymentScheduleScreen> {

  @override

    void initState() {
      Provider.of<CustomerView>(context, listen: false).getPaymentSchedule(index: widget.index, productIndex: widget.productIndex);
      super.initState();
    }



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
        itemCount: Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].paymentSchedule.length,
        itemBuilder: (BuildContext context, int paymentIndex) {
          return PaymentScheduleWidget(index: widget.index,
              productIndex: widget.productIndex,
              paymentIndex: paymentIndex);
        },
      ),
    );
  }
}
