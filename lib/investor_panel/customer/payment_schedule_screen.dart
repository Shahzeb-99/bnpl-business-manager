// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:ecommerce_bnql/investor_panel/customer/paymentScheduleWidget.dart';
import 'package:ecommerce_bnql/investor_panel/customer/payment_schedule_class.dart';
import 'package:ecommerce_bnql/investor_panel/customer/transaction_history_screen.dart';
import 'package:ecommerce_bnql/investor_panel/invoice_investor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../investor_panel/view_model/viewmodel_customers.dart';
import '../view_model/viewmodel_user.dart';

class PaymentScheduleScreen extends StatefulWidget {
  const PaymentScheduleScreen({Key? key, required this.paymentList, required this.productIndex, required this.index}) : super(key: key);

  final List<PaymentSchedule> paymentList;
  final int productIndex;
  final int index;

  @override
  State<PaymentScheduleScreen> createState() => _PaymentScheduleScreenState();
}

class _PaymentScheduleScreenState extends State<PaymentScheduleScreen> {
  @override
  void initState() {
    Provider.of<CustomerViewInvestor>(context, listen: false).getPaymentSchedule(index: widget.index, productIndex: widget.productIndex);
    super.initState();
  }

  late DateTime dateTime;
  late TimeOfDay time;
  final formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Payment Schedule',
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFFE56E14),
                ),
              ),
            ),
            IconButton(
                color: const Color(0xFFE56E14),
                onPressed: () async {
                  final service = PdfInvoiceServiceInvestor();
                  final date = await service.createPaymentList(
                    Provider.of<CustomerViewInvestor>(context, listen: false)
                        .allCustomers[widget.index]
                        .purchases[widget.productIndex]
                        .paymentSchedule,
                    Provider.of<CustomerViewInvestor>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex],
                  );

                  service.savePdfFile('Order Status', date);
                },
                icon: const Icon(Icons.receipt)),
            Provider.of<UserViewModel>(context, listen: false).readWrite
                ? IconButton(
                    color: const Color(0xFFE56E14),
                    onPressed: () {
                      time = TimeOfDay.now();
                      dateTime = DateTime.now();
                      final TextEditingController moneyController = TextEditingController();
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Add Money',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: InkWell(
                                        onTap: () async {
                                          DateTime? newDate = await showDatePicker(
                                            context: context,
                                            initialDate: dateTime,
                                            initialDatePickerMode: DatePickerMode.day,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          setState(() {
                                            dateTime = newDate!;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            DateFormat.yMMMMEEEEd().format(dateTime),
                                            style: const TextStyle(color: Color(0xFFE56E14), fontSize: 20, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                          setState(() {
                                            time = newTime!;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            DateFormat.jms().format(DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute)),
                                            style: const TextStyle(color: Color(0xFFE56E14), fontSize: 20, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              key: formKey,
                                              autofocus: true,
                                              controller: moneyController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              decoration: kDecoration.inputBox('Amount', 'PKR'),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'This field is required';
                                                } else if (int.parse(value) >
                                                    Provider.of<CustomerViewInvestor>(context, listen: false)
                                                        .allCustomers[widget.index]
                                                        .purchases[widget.productIndex]
                                                        .outstandingBalance) {
                                                  return 'Value greater than outstanding amount';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          IconButton(
                                              color: Colors.purple.shade900,
                                              onPressed: () async {
                                                {
                                                  if (formKey.currentState!.validate()) {
                                                    int length = Provider.of<CustomerViewInvestor>(context, listen: false)
                                                        .allCustomers[widget.index]
                                                        .purchases[widget.productIndex]
                                                        .paymentSchedule
                                                        .length;
                                                    int index = 0;
                                                    int newPayment = int.parse(moneyController.text);
                                                    int transactionAmount = newPayment;

                                                    for (PaymentSchedule payment in Provider.of<CustomerViewInvestor>(context, listen: false)
                                                        .allCustomers[widget.index]
                                                        .purchases[widget.productIndex]
                                                        .paymentSchedule) {
                                                      if (payment.isPaid) {
                                                        index++;
                                                        length--;
                                                      }
                                                    }
                                                    if (index == Provider.of<CustomerViewInvestor>(context, listen: false)
                                                        .allCustomers[widget.index]
                                                        .purchases[widget.productIndex]
                                                        .paymentSchedule.length - 1) {
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .remainingAmount -= newPayment;

                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .addTransaction(amount: newPayment, dateTime: dateTime);
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .updateFirestore();
                                                      if (Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount ==
                                                          0) {
                                                        Provider.of<CustomerViewInvestor>(context, listen: false)
                                                            .allCustomers[widget.index]
                                                            .purchases[widget.productIndex]
                                                            .paymentSchedule[index]
                                                            .isPaid = true;
                                                      }
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .updateFirestore();
                                                    } else if (newPayment <
                                                        Provider.of<CustomerViewInvestor>(context, listen: false)
                                                            .allCustomers[widget.index]
                                                            .purchases[widget.productIndex]
                                                            .paymentSchedule[index]
                                                            .remainingAmount) {
                                                      int outstandingAmount = 0;

                                                      outstandingAmount = Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount -
                                                          newPayment;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .remainingAmount = 0;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .amount = newPayment;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .addTransaction(amount: newPayment, dateTime: dateTime);
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .isPaid = true;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .updateFirestore();
                                                      index++;
                                                      length--;
                                                      int roundedPayment = outstandingAmount ~/ length;

                                                      for (index;
                                                          index <
                                                              Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                  .allCustomers[widget.index]
                                                                  .purchases[widget.productIndex]
                                                                  .paymentSchedule
                                                                  .length;
                                                          index++) {
                                                        if (index !=
                                                            Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                    .allCustomers[widget.index]
                                                                    .purchases[widget.productIndex]
                                                                    .paymentSchedule
                                                                    .length -
                                                                1) {
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .amount += roundedPayment;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount += roundedPayment;
                                                          outstandingAmount -= roundedPayment;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .updateFirestore();
                                                        } else {
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .amount += outstandingAmount;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount += outstandingAmount;
                                                          outstandingAmount = 0;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .updateFirestore();
                                                        }
                                                      }
                                                    } else if (newPayment >
                                                            Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                .allCustomers[widget.index]
                                                                .purchases[widget.productIndex]
                                                                .paymentSchedule[index]
                                                                .remainingAmount &&
                                                        Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                    .allCustomers[widget.index]
                                                                    .purchases[widget.productIndex]
                                                                    .outstandingBalance -
                                                                newPayment >=
                                                            500) {
                                                      int outstandingAmount = newPayment -
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .addTransaction(
                                                              amount: Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                  .allCustomers[widget.index]
                                                                  .purchases[widget.productIndex]
                                                                  .paymentSchedule[index]
                                                                  .remainingAmount,
                                                              dateTime: dateTime);
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .remainingAmount = 0;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .isPaid = true;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .updateFirestore();
                                                      index++;
                                                      length--;
                                                      int roundedPayment = outstandingAmount ~/ length;

                                                      for (index;
                                                          index <
                                                              Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                  .allCustomers[widget.index]
                                                                  .purchases[widget.productIndex]
                                                                  .paymentSchedule
                                                                  .length;
                                                          index++) {
                                                        if (index !=
                                                            Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                    .allCustomers[widget.index]
                                                                    .purchases[widget.productIndex]
                                                                    .paymentSchedule
                                                                    .length -
                                                                1) {
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount -= roundedPayment;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .addTransaction(
                                                                  amount: roundedPayment,
                                                                  dateTime:
                                                                      DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute));
                                                          outstandingAmount -= roundedPayment;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .updateFirestore();
                                                        } else {
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .remainingAmount -= outstandingAmount;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .addTransaction(
                                                                  amount: outstandingAmount,
                                                                  dateTime:
                                                                      DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute));
                                                          outstandingAmount = 0;
                                                          Provider.of<CustomerViewInvestor>(context, listen: false)
                                                              .allCustomers[widget.index]
                                                              .purchases[widget.productIndex]
                                                              .paymentSchedule[index]
                                                              .updateFirestore();
                                                        }
                                                      }
                                                    } else if (newPayment >
                                                            Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                .allCustomers[widget.index]
                                                                .purchases[widget.productIndex]
                                                                .paymentSchedule[index]
                                                                .remainingAmount &&
                                                        Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                    .allCustomers[widget.index]
                                                                    .purchases[widget.productIndex]
                                                                    .outstandingBalance -
                                                                newPayment <=
                                                            500) {
                                                      for (var payment in Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule) {
                                                        setState(() {
                                                          if (!payment.isPaid) {
                                                            if (newPayment >= payment.remainingAmount) {
                                                              payment.isPaid = true;
                                                              newPayment = newPayment - payment.remainingAmount;
                                                              payment.addTransaction(
                                                                  amount: payment.remainingAmount,
                                                                  dateTime:
                                                                      DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute));
                                                              payment.remainingAmount = 0;
                                                            } else {
                                                              payment.remainingAmount = payment.remainingAmount - newPayment;

                                                              payment.addTransaction(
                                                                  amount: newPayment,
                                                                  dateTime:
                                                                      DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute));
                                                              newPayment = 0;
                                                            }
                                                          }
                                                        });

                                                        payment.updateFirestore();
                                                      }
                                                    } else {
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .addTransaction(
                                                              amount: Provider.of<CustomerViewInvestor>(context, listen: false)
                                                                  .allCustomers[widget.index]
                                                                  .purchases[widget.productIndex]
                                                                  .paymentSchedule[index]
                                                                  .remainingAmount,
                                                              dateTime: dateTime);
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .remainingAmount = 0;
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .paymentSchedule[index]
                                                          .isPaid = true;
                                                    }
                                                    Provider.of<CustomerViewInvestor>(context, listen: false)
                                                        .allCustomers[widget.index]
                                                        .purchases[widget.productIndex]
                                                        .addTransaction(
                                                            amount: transactionAmount,
                                                            dateTime: DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute))
                                                        .whenComplete(() {
                                                      Provider.of<CustomerViewInvestor>(context, listen: false)
                                                          .allCustomers[widget.index]
                                                          .purchases[widget.productIndex]
                                                          .updateCustomBatchTransaction(amount: transactionAmount);
                                                      updateLocalState(context, transactionAmount);
                                                    });
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                    final service = PdfInvoiceServiceInvestor();
                                                    final date = await service.createPaymentReceipt(
                                                        Provider.of<CustomerViewInvestor>(context, listen: false)
                                                            .allCustomers[widget.index]
                                                            .purchases[widget.productIndex],
                                                        transactionAmount,
                                                        dateTime);
                                                    service.savePdfFile('Order Status', date);
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.navigate_next))
                                        ],
                                      ),
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
                : const SizedBox()
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Product Name : ${Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].productName}',
              style: const TextStyle(fontSize: 20),
            ),
            Text('Investor Name : ${Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].vendorName}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Selling Amount : ${Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].sellingAmount.toString()}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Purchase Amount : ${Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].purchaseAmount.toString()}',
                style: const TextStyle(fontSize: 20)),
            Text(
                'Profit : ${Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].sellingAmount - Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].purchaseAmount}',
                style: const TextStyle(fontSize: 20)),
            TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  Colors.grey.shade200,
                )),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TransactionHistoryScreen(productIndex: widget.productIndex, index: widget.index)));
                },
                child: const Text('Transaction History')),
            Expanded(
              child: ListView.builder(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount:
                    Provider.of<CustomerViewInvestor>(context).allCustomers[widget.index].purchases[widget.productIndex].paymentSchedule.length,
                itemBuilder: (BuildContext context, int paymentIndex) {
                  return PaymentScheduleWidget(index: widget.index, productIndex: widget.productIndex, paymentIndex: paymentIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateLocalState(BuildContext context, int amount) {
    Provider.of<CustomerViewInvestor>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].outstandingBalance -= amount;
    Provider.of<CustomerViewInvestor>(context, listen: false).allCustomers[widget.index].purchases[widget.productIndex].amountPaid += amount;
    Provider.of<CustomerViewInvestor>(context, listen: false).allCustomers[widget.index].outstandingBalance -= amount;
    Provider.of<CustomerViewInvestor>(context, listen: false).allCustomers[widget.index].paidAmount += amount;
  }
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? const Text('PKR') : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      hintStyle: const TextStyle(
        color: Color(0xFFE56E14),
      ),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
