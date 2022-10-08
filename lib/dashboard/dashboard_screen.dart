import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/dashboard/amount_spend_screen.dart';
import 'package:ecommerce_bnql/dashboard/outstanding_balance_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../vendor/all_vendor_screen.dart';

enum DashboardFilterOptions { all, oneMonth, sixMonths }

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  final TextEditingController moneyController = TextEditingController();

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading=false;

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
                ListTile(
                  title: const Text('All Time'),
                  leading: Radio<DashboardFilterOptions?>(
                    value: DashboardFilterOptions.all,
                    groupValue: Provider.of<DashboardView>(context).option,
                    onChanged: (value) {
                      setState(() {
                        Provider.of<DashboardView>(context, listen: false)
                            .option = value!;
                        Provider.of<DashboardView>(context, listen: false)
                            .getFinancials();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Last Month'),
                  leading: Radio<DashboardFilterOptions?>(
                    value: DashboardFilterOptions.oneMonth,
                    groupValue: Provider.of<DashboardView>(context).option,
                    onChanged: (value) {
                      setState(() {
                        Provider.of<DashboardView>(context, listen: false)
                            .option = value!;
                        Provider.of<DashboardView>(context, listen: false)
                            .getMonthlyFinancials();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Last Six Months'),
                  leading: Radio<DashboardFilterOptions?>(
                    value: DashboardFilterOptions.sixMonths,
                    groupValue: Provider.of<DashboardView>(context).option,
                    onChanged: (value) {
                      setState(() {
                        Provider.of<DashboardView>(context, listen: false)
                            .option = value!;
                        Provider.of<DashboardView>(context, listen: false)
                            .getMonthlyFinancials();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: SafeArea(
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
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllOutstandingBalance()));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Remaining Installments',
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
                                      child: Provider.of<DashboardView>(context)
                                                  .option ==
                                              DashboardFilterOptions.all
                                          ? Text(
                                              '${Provider.of<DashboardView>(context).dashboardData.totalOutstandingBalance.toString()} Rupees',
                                            )
                                          : Text(
                                              '${Provider.of<DashboardView>(context).outstandingBalance} Rupees',
                                            ),
                                    )
                                  ],
                                ))),
                      ),
                      Expanded(
                        child: Card(
                            elevation: 5,
                            color: const Color(0xFFD6EFF2),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AllAmountSpend()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    child: Center(
                                      child: Text(
                                        'Recovery account',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Expanded(
                                    child: Provider.of<DashboardView>(context)
                                                .option ==
                                            DashboardFilterOptions.all
                                        ? Text(
                                            '${Provider.of<DashboardView>(context).dashboardData.totalAmountPaid.toString()} Rupees',
                                          )
                                        : Text(
                                            '${Provider.of<DashboardView>(context).amount_paid} Rupees',
                                          ),
                                  )
                                ],
                              ),
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
                                      'Purchase account',
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
                                  child: Provider.of<DashboardView>(context)
                                              .option ==
                                          DashboardFilterOptions.all
                                      ? Text(
                                          '${Provider.of<DashboardView>(context).dashboardData.totalCost.toString()} Rupees',
                                        )
                                      : Text(
                                          '${Provider.of<DashboardView>(context).total_cost} Rupees',
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
                                    'Calculative profit',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Expanded(
                                child:
                                    Provider.of<DashboardView>(context).option ==
                                            DashboardFilterOptions.all
                                        ? Text(
                                            '${Provider.of<DashboardView>(context).dashboardData.profit.toString()} Rupees',
                                          )
                                        : Text(
                                            '${Provider.of<DashboardView>(context).outstandingBalance + Provider.of<DashboardView>(context).amount_paid - Provider.of<DashboardView>(context).total_cost} Rupees',
                                          ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
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
                                                      decoration:
                                                          kDecoration.inputBox(
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
                                                      splashColor:
                                                          Colors.tealAccent,
                                                      onPressed: () async {
                                                        setState(() {
                                                          loading=true;
                                                        });
                                                        final cloud =
                                                            FirebaseFirestore
                                                                .instance;
                                                       await cloud
                                                            .collection(
                                                                'financials')
                                                            .doc('finance')
                                                            .update({
                                                          'cash_available':
                                                              FieldValue.increment(
                                                                  int.parse(widget
                                                                      .moneyController
                                                                      .text))
                                                        }).whenComplete(() {
                                                          Provider.of<
                                                                      DashboardView>(
                                                                  context,
                                                                  listen: false)
                                                              .dashboardData
                                                              .cashAvailable = Provider
                                                                      .of<DashboardView>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                  .dashboardData
                                                                  .cashAvailable +
                                                              int.parse(widget
                                                                  .moneyController
                                                                  .text);
                                                          widget.moneyController
                                                              .clear();
                                                          Navigator.pop(context);
                                                        });
                                                        loading= false;
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
                                        'Cash in Hand',
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
                      Expanded(
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
                                                'Add Expenses',
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
                                                      decoration:
                                                          kDecoration.inputBox(
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
                                                      splashColor:
                                                          Colors.tealAccent,
                                                      onPressed: () {
                                                        final cloud =
                                                            FirebaseFirestore
                                                                .instance;
                                                        cloud
                                                            .collection(
                                                                'financials')
                                                            .doc('finance')
                                                            .update({
                                                          'expenses': FieldValue
                                                              .increment(
                                                                  int.parse(widget
                                                                      .moneyController
                                                                      .text))
                                                        }).whenComplete(() {
                                                          Provider.of<
                                                                      DashboardView>(
                                                                  context,
                                                                  listen: false)
                                                              .dashboardData
                                                              .expenses = Provider
                                                                      .of<DashboardView>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                  .dashboardData
                                                                  .expenses +
                                                              int.parse(widget
                                                                  .moneyController
                                                                  .text);
                                                          widget.moneyController
                                                              .clear();
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
                                        'Expenses',
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
                                      '${Provider.of<DashboardView>(context).dashboardData.expenses.toString()} Rupees',
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
