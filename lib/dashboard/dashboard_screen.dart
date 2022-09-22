import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../vendor/all_vendor_screen.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  final TextEditingController moneyController = TextEditingController();

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    Provider.of<DashboardView>(context, listen: false).getFinancials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ));
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllCustomersScreen()));
                  },
                  child: const Text('Customers'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllVendorScreen()));
                  },
                  child: const Text('Vendors'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                          elevation: 5,
                          color: const Color(0xFFD6EFF2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Outstanding Balance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Expanded(
                                child: Text(
                                  '${Provider.of<DashboardView>(context).dashboardData.totalOutstandingBalance.toString()} Rupees',
                                ),
                              )
                            ],
                          )),
                    ),
                    Expanded(
                      child: Card(
                          elevation: 5,
                          color: const Color(0xFFD6EFF2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Amount Paid',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Expanded(
                                child: Text(
                                  '${Provider.of<DashboardView>(context).dashboardData.totalAmountPaid.toString()} Rupees',
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                          elevation: 5,
                          color: const Color(0xFFD6EFF2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Total Cost',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Expanded(
                                child: Text(
                                  '${Provider.of<DashboardView>(context).dashboardData.totalCost.toString()} Rupees',
                                ),
                              )
                            ],
                          )),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        color: const Color(0xFFD6EFF2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Total Profit',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Expanded(
                              child: Text(
                                  '${Provider.of<DashboardView>(context).dashboardData.profit} Rupees '),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Card(
                    elevation: 5,
                    color: const Color(0xFFD6EFF2),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
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
                                              controller:
                                                  widget.moneyController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: kDecoration.inputBox(
                                                  'Amount', 'PKR'),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'This field is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          IconButton(
                                              splashColor: Colors.tealAccent,
                                              onPressed: () {
                                                final cloud =
                                                    FirebaseFirestore.instance;
                                                cloud
                                                    .collection('financials')
                                                    .doc('finance')
                                                    .update({
                                                  'cash_available':
                                                      FieldValue.increment(
                                                          int.parse(widget
                                                              .moneyController
                                                              .text))
                                                }).whenComplete(() {
                                                  Provider.of<DashboardView>(
                                                              context,
                                                              listen: false)
                                                          .dashboardData
                                                          .cashAvailable =
                                                      Provider.of<DashboardView>(
                                                                  context,
                                                                  listen: false)
                                                              .dashboardData
                                                              .cashAvailable +
                                                          int.parse(widget
                                                              .moneyController
                                                              .text);
                                                  widget.moneyController.clear();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.navigate_next))
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Available Cash',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            child: Text(
                              '${Provider.of<DashboardView>(context).dashboardData.cashAvailable.toString()} Rupees',
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
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
