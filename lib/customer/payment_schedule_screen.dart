import 'package:ecommerce_bnql/customer/paymentScheduleWidget.dart';
import 'package:ecommerce_bnql/customer/payment_schedule_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../view_model/viewmodel_customers.dart';

class PaymentScheduleScreen extends StatefulWidget {
  const PaymentScheduleScreen(
      {Key? key,
      required this.paymentList,
      required this.productIndex,
      required this.index})
      : super(key: key);

  final List<PaymentSchedule> paymentList;
  final int productIndex;
  final int index;

  @override
  State<PaymentScheduleScreen> createState() => _PaymentScheduleScreenState();
}

class _PaymentScheduleScreenState extends State<PaymentScheduleScreen> {
  @override
  void initState() {
    Provider.of<CustomerView>(context, listen: false).getPaymentSchedule(
        index: widget.index, productIndex: widget.productIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Schedule',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            IconButton(
                onPressed: () {
                  final TextEditingController moneyController =
                      TextEditingController();
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment.stretch,
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Add Money',
                                  style: TextStyle(fontSize: 25),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: moneyController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: kDecoration.inputBox(
                                            'Amount', 'PKR'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                        splashColor: Colors.tealAccent,
                                        onPressed: () {
                                          if (moneyController.text.isNotEmpty) {
                                            int newPayment =
                                                int.parse(moneyController.text);
                                            moneyController.clear();
                                            Provider.of<CustomerView>(context,
                                                    listen: false)
                                                .allCustomers[widget.index]
                                                .purchases[widget.productIndex]
                                                .updateCustomTransaction(
                                                    amount: newPayment);
                                            for (var payment in Provider.of<
                                                        CustomerView>(context,
                                                    listen: false)
                                                .allCustomers[widget.index]
                                                .purchases[widget.productIndex]
                                                .paymentSchedule) {
                                              setState(() {
                                                if (!payment.isPaid) {
                                                  if (newPayment >=
                                                      payment.remainingAmount) {
                                                    payment.isPaid = true;
                                                    newPayment = newPayment -
                                                        payment.remainingAmount;
                                                    payment.remainingAmount = 0;
                                                  } else {
                                                    payment.remainingAmount =
                                                        payment.remainingAmount -
                                                            newPayment;
                                                    newPayment = 0;
                                                  }
                                                }
                                              });

                                              payment.updateFirestore();

                                            }
                                            if(newPayment > 0){
                                              Provider.of<CustomerView>(context,
                                                  listen: false)
                                                  .allCustomers[widget.index]
                                                  .purchases[widget.productIndex]
                                                  .updateCustomTransaction(
                                                  amount: -newPayment);

                                            }
                                          }

                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.navigate_next))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name : ${Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].productName}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
                'Vendor Name : ${Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].vendorName}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Selling Amount : ${Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].sellingAmount.toString()}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Purchase Amount : ${Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].purchaseAmount.toString()}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Profit : ${Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].sellingAmount - Provider.of<CustomerView>(context).allCustomers[widget.index].purchases[widget.productIndex].purchaseAmount}',
                style: const TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: Provider.of<CustomerView>(context)
                    .allCustomers[widget.index]
                    .purchases[widget.productIndex]
                    .paymentSchedule
                    .length,
                itemBuilder: (BuildContext context, int paymentIndex) {
                  return PaymentScheduleWidget(
                      index: widget.index,
                      productIndex: widget.productIndex,
                      paymentIndex: paymentIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? const Text('PKR') : null,
      filled: true,
      fillColor: const Color(0xFFD6EFF2),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
    );
  }
}
