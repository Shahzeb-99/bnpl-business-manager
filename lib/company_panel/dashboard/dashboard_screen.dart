// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../customer/all_customer_screen.dart';
import '../vendor/all_vendor_screen.dart';
import '../view_model/viewmodel_dashboard.dart';
import 'amountPaid_button/amount_spend_screen.dart';
import 'outstandingAmount_button/outstanding_balance_screen.dart';

enum DashboardFilterOptions { all, oneMonth, sixMonths }

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  final TextEditingController moneyController = TextEditingController();

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = false;

  @override
  void initState() {
    Provider.of<DashboardView>(context, listen: false).getAllFinancials();

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
              ));
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 25),
            ),
            IconButton(
              splashRadius: 25,
              onPressed: () async {
                if (Provider.of<DashboardView>(context, listen: false).option ==
                    DashboardFilterOptions.all) {
                  setState(() {
                    loading = true;
                  });
                  await Provider.of<DashboardView>(context, listen: false)
                      .getAllFinancials();
                  setState(() {
                    loading = false;
                  });
                } else if (Provider.of<DashboardView>(context, listen: false)
                        .option ==
                    DashboardFilterOptions.sixMonths) {
                  setState(() {
                    loading = true;
                  });
                  await Provider.of<DashboardView>(context, listen: false)
                      .getMonthlyFinancials();
                  setState(() {
                    loading = false;
                  });
                } else if (Provider.of<DashboardView>(context, listen: false)
                        .option ==
                    DashboardFilterOptions.oneMonth) {
                  setState(() {
                    loading = true;
                  });
                  await Provider.of<DashboardView>(context, listen: false)
                      .getMonthlyFinancials();
                  setState(() {
                    loading = false;
                  });
                }
              },
              icon: const Icon(Icons.refresh_rounded),
            )
          ],
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
                    onChanged: (value) async {
                      Navigator.pop(context);
                      loading = true;
                      setState(() {
                        Provider.of<DashboardView>(context, listen: false)
                            .option = value!;
                      });
                      await Provider.of<DashboardView>(context, listen: false)
                          .getAllFinancials();
                      loading = false;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Last Month'),
                  leading: Radio<DashboardFilterOptions?>(
                    value: DashboardFilterOptions.oneMonth,
                    groupValue: Provider.of<DashboardView>(context).option,
                    onChanged: (value) async {
                      Navigator.pop(context);
                      loading = true;
                      setState(() {
                        Provider.of<DashboardView>(context, listen: false)
                            .option = value!;
                      });
                      await Provider.of<DashboardView>(context, listen: false)
                          .getMonthlyFinancials();

                      loading = false;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Last Six Months'),
                  leading: Radio<DashboardFilterOptions?>(
                    value: DashboardFilterOptions.sixMonths,
                    groupValue: Provider.of<DashboardView>(context).option,
                    onChanged: (value) async {
                      Navigator.pop(context);
                      loading = true;
                      setState(() {
                        Provider.of<DashboardView>(context, listen: false)
                            .option = value!;
                      });
                      await Provider.of<DashboardView>(context, listen: false)
                          .getMonthlyFinancials();

                      loading = false;
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
        blur: 5,
        color: Colors.transparent,
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
                            color: const Color(0xFF2D2C3F),
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
                                            color: Color(0xFFB6B8C0),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Expanded(
                                        child: Provider.of<DashboardView>(
                                                        context)
                                                    .option ==
                                                DashboardFilterOptions.all
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    Provider.of<DashboardView>(
                                                            context)
                                                        .dashboardData
                                                        .totalOutstandingBalance
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: Provider.of<
                                                                            DashboardView>(
                                                                        context)
                                                                    .dashboardData
                                                                    .totalOutstandingBalance <
                                                                1000000
                                                            ? 30
                                                            : 20,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  const Text(
                                                    ' Rupees',
                                                    style: TextStyle(
                                                      color: Color(0xFF8D8E98),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    Provider.of<DashboardView>(
                                                            context)
                                                        .monthlyFinancials
                                                        .totalOutstandingBalance
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: Provider.of<
                                                                            DashboardView>(
                                                                        context)
                                                                    .monthlyFinancials
                                                                    .totalOutstandingBalance <
                                                                1000000
                                                            ? 30
                                                            : 20,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  const Text(
                                                    ' Rupees',
                                                    style: TextStyle(
                                                      color: Color(0xFF8D8E98),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                  ],
                                ))),
                      ),
                      Expanded(
                        child: Card(
                            elevation: 5,
                            color: const Color(0xFF2D2C3F),
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
                                        style: TextStyle(
                                          color: Color(0xFFB6B8C0),
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
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  Provider.of<DashboardView>(
                                                          context)
                                                      .dashboardData
                                                      .totalAmountPaid
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: Provider.of<
                                                                          DashboardView>(
                                                                      context)
                                                                  .dashboardData
                                                                  .totalAmountPaid <
                                                              1000000
                                                          ? 30
                                                          : 20,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                const Text(
                                                  ' Rupees',
                                                  style: TextStyle(
                                                    color: Color(0xFF8D8E98),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  Provider.of<DashboardView>(
                                                          context)
                                                      .monthlyFinancials
                                                      .totalAmountPaid
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: Provider.of<
                                                                          DashboardView>(
                                                                      context)
                                                                  .monthlyFinancials
                                                                  .totalAmountPaid <
                                                              1000000
                                                          ? 30
                                                          : 20,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                const Text(
                                                  ' Rupees',
                                                  style: TextStyle(
                                                    color: Color(0xFF8D8E98),
                                                  ),
                                                ),
                                              ],
                                            ))
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
                            color: const Color(0xFF2D2C3F),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'Purchase account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFB6B8C0),
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
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                Provider.of<DashboardView>(
                                                        context)
                                                    .dashboardData
                                                    .totalCost
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        Provider.of<DashboardView>(
                                                                        context)
                                                                    .dashboardData
                                                                    .totalCost <
                                                                1000000
                                                            ? 30
                                                            : 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              const Text(
                                                ' Rupees',
                                                style: TextStyle(
                                                  color: Color(0xFF8D8E98),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                Provider.of<DashboardView>(
                                                        context)
                                                    .monthlyFinancials
                                                    .totalCost
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        Provider.of<DashboardView>(
                                                                        context)
                                                                    .dashboardData
                                                                    .totalCost <
                                                                1000000
                                                            ? 30
                                                            : 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              const Text(
                                                ' Rupees',
                                                style: TextStyle(
                                                  color: Color(0xFF8D8E98),
                                                ),
                                              ),
                                            ],
                                          ))
                              ],
                            )),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 5,
                          color: const Color(0xFF2D2C3F),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Calculative profit',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFB6B8C0),
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
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            Provider.of<DashboardView>(context)
                                                .dashboardData
                                                .profit
                                                .toString(),
                                            style: TextStyle(
                                                fontSize:
                                                    Provider.of<DashboardView>(
                                                                    context)
                                                                .dashboardData
                                                                .profit <
                                                            1000000
                                                        ? 30
                                                        : 20,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          const Text(
                                            ' Rupees',
                                            style: TextStyle(
                                              color: Color(0xFF8D8E98),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '${Provider.of<DashboardView>(context).monthlyFinancials.profit}',
                                            style: TextStyle(
                                                fontSize:
                                                    Provider.of<DashboardView>(
                                                                    context)
                                                                .monthlyFinancials
                                                                .profit <
                                                            1000000
                                                        ? 30
                                                        : 20,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          const Text(
                                            ' Rupees',
                                            style: TextStyle(
                                              color: Color(0xFF8D8E98),
                                            ),
                                          ),
                                        ],
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
                            color: const Color(0xFF2D2C3F),
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
                                            color: Color(0xFF2D2C3F),
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
                                                      controller: widget
                                                          .moneyController,
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
                                                      onPressed: () async {

                                                        if (widget
                                                            .moneyController
                                                            .text
                                                            .isNotEmpty) {
                                                          setState(() {
                                                            loading = true;
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
                                                            Provider.of<DashboardView>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .dashboardData
                                                                .cashAvailable = Provider.of<
                                                                            DashboardView>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .dashboardData
                                                                    .cashAvailable +
                                                                int.parse(widget
                                                                    .moneyController
                                                                    .text);
                                                            widget
                                                                .moneyController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                        }
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
                                          color: Color(0xFFB6B8C0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        Provider.of<DashboardView>(context)
                                            .dashboardData
                                            .cashAvailable
                                            .toString(),
                                        style: TextStyle(
                                            fontSize:
                                                Provider.of<DashboardView>(
                                                                context)
                                                            .dashboardData
                                                            .cashAvailable <
                                                        1000000
                                                    ? 30
                                                    : 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const Text(
                                        ' Rupees',
                                        style: TextStyle(
                                          color: Color(0xFF8D8E98),
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            )),
                      ),
                      Expanded(
                        child: Card(
                            elevation: 5,
                            color: const Color(0xFF2D2C3F),
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
                                            color: Color(0xFF2D2C3F),
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
                                                      controller: widget
                                                          .moneyController,
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
                                                      onPressed: () {
                                                        final cloud =
                                                            FirebaseFirestore
                                                                .instance;
                                                        cloud
                                                            .collection(
                                                                'financials')
                                                            .doc('finance')
                                                            .update(
                                                          {
                                                            'expenses': FieldValue
                                                                .increment(int
                                                                    .parse(widget
                                                                        .moneyController
                                                                        .text)),
                                                            'cash_available': FieldValue
                                                                .increment(-int
                                                                    .parse(widget
                                                                        .moneyController
                                                                        .text))
                                                          },
                                                        ).whenComplete(
                                                          () {
                                                            Provider.of<DashboardView>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .dashboardData
                                                                .expenses = Provider.of<
                                                                            DashboardView>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .dashboardData
                                                                    .expenses +
                                                                int.parse(widget
                                                                    .moneyController
                                                                    .text);
                                                            Provider.of<DashboardView>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .dashboardData
                                                                .cashAvailable = Provider.of<
                                                                            DashboardView>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .dashboardData
                                                                    .cashAvailable -
                                                                int.parse(widget
                                                                    .moneyController
                                                                    .text);
                                                            widget
                                                                .moneyController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
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
                                          color: Color(0xFFB6B8C0),
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        Provider.of<DashboardView>(context)
                                            .dashboardData
                                            .expenses
                                            .toString(),
                                        style: TextStyle(
                                            fontSize:
                                                Provider.of<DashboardView>(
                                                                context)
                                                            .dashboardData
                                                            .expenses <
                                                        1000000
                                                    ? 30
                                                    : 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const Text(
                                        ' Rupees',
                                        style: TextStyle(
                                          color: Color(0xFF8D8E98),
                                        ),
                                      ),
                                    ],
                                  ))
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
      fillColor: const Color(0xFF2D2C3F),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
