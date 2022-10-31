// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/company_panel/dashboard/expenses_screen.dart';
import 'package:ecommerce_bnql/company_panel/dashboard/transactions_screen.dart';
import 'package:ecommerce_bnql/investor_panel/pageview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_model/viewmodel_dashboard.dart';
import 'amountPaid_button/amount_spend_screen.dart';
import 'outstandingAmount_button/outstanding_balance_screen.dart';

enum DashboardFilterOptions { all, oneMonth, sixMonths }

class DashboardCompany extends StatefulWidget {
  DashboardCompany({Key? key}) : super(key: key);

  final TextEditingController moneyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  State<DashboardCompany> createState() => _DashboardCompanyState();
}

class _DashboardCompanyState extends State<DashboardCompany> {
  bool loading = false;
  int filterIndex = 0;

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
            const Expanded(
              child: Text(
                'Dashboard Company',
                overflow: TextOverflow.fade,
                style: TextStyle(fontSize: 25),
              ),
            ),
            loading != true
                ? IconButton(
                    splashRadius: 25,
                    onPressed: () async {
                      if (Provider.of<DashboardView>(context, listen: false)
                              .option ==
                          DashboardFilterOptions.all) {
                        setState(() {
                          loading = true;
                        });
                        await Provider.of<DashboardView>(context, listen: false)
                            .getAllFinancials();
                        setState(() {
                          loading = false;
                        });
                      } else if (Provider.of<DashboardView>(context,
                                  listen: false)
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
                      } else if (Provider.of<DashboardView>(context,
                                  listen: false)
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
                : const RefreshProgressIndicator(
                    backgroundColor: Color(0xFF1A1C33),
                    color: Colors.white,
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
                const Center(
                    child: Text(
                  'Company Panel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                Expanded(child: Container()),
                OutlinedButton(
                    child: const Text('Switch to Investor Account'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                          (route) => false);
                    })
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: CupertinoSegmentedControl<int>(
                  unselectedColor: const Color(0xFF1A1C33),
                  groupValue: filterIndex,
                  onValueChanged: (value) async {
                    setState(() {
                      filterIndex = value;
                    });
                    if (value == 0) {
                      Provider.of<DashboardView>(context, listen: false)
                          .option = DashboardFilterOptions.all;
                      setState(() {
                        loading = true;
                      });
                      await Provider.of<DashboardView>(context, listen: false)
                          .getAllFinancials();
                      setState(() {
                        loading = false;
                      });
                    } else if (value == 1) {
                      setState(() {
                        loading = true;
                      });
                      Provider.of<DashboardView>(context, listen: false)
                          .option = DashboardFilterOptions.oneMonth;

                      await Provider.of<DashboardView>(context, listen: false)
                          .getMonthlyFinancials();
                      setState(() {
                        loading = false;
                      });
                    } else {
                      setState(() {
                        loading = true;
                      });
                      Provider.of<DashboardView>(context, listen: false)
                          .option = DashboardFilterOptions.sixMonths;

                      await Provider.of<DashboardView>(context, listen: false)
                          .getMonthlyFinancials();
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  children: const {
                    0: Text("All Time"),
                    1: Text("This Month"),
                    2: Text("Last 6 Months"),
                  },
                ),
              ),
              Expanded(
                flex: 4,
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
              Expanded(
                flex: 4,
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
                                          textBaseline: TextBaseline.alphabetic,
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
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                          elevation: 5,
                          color: const Color(0xFF2D2C3F),
                          child: InkWell(
                            onTap: () {
                              {
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Center(
                                                child: Text(
                                                  'Cash in Hand',
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: TextFormField(
                                                  autofocus: true,
                                                  controller:
                                                      widget.moneyController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp('[0-9-]'))
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
                                              TextFormField(
                                                maxLines: 5,
                                                autofocus: true,
                                                controller: widget
                                                    .descriptionController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    kDecoration.inputBox(
                                                        'Description', ''),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please add a description for expense';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    if (widget.moneyController
                                                        .text.isNotEmpty) {
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
                                                                    .text)),
                                                      }).whenComplete(() {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'financials')
                                                            .doc('finance')
                                                            .collection(
                                                                'transactions')
                                                            .add({
                                                          'amount': int.parse(
                                                              widget
                                                                  .moneyController
                                                                  .text),
                                                          'time':
                                                              Timestamp.now(),
                                                          'description': widget
                                                              .descriptionController
                                                              .text
                                                        });
                                                        Provider.of<DashboardView>(
                                                                    context,
                                                                    listen: false)
                                                                .dashboardData
                                                                .cashAvailable +=
                                                            int.parse(widget
                                                                .moneyController
                                                                .text);

                                                        widget.moneyController
                                                            .clear();
                                                        widget
                                                            .descriptionController
                                                            .clear();
                                                        Navigator.pop(context);
                                                      });
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    }
                                                  },
                                                  child:
                                                      const Text('Add Money'))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            onLongPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TransactionScreen()));
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
                                          fontSize: Provider.of<DashboardView>(
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
                            onLongPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExpensesScreen()));
                            },
                            onTap: () {
                              showModalBottomSheet<void>(
                                isScrollControlled: true,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Center(
                                              child: Text(
                                                'Expenses',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: TextFormField(
                                                autofocus: true,
                                                controller:
                                                    widget.moneyController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp('[0-9-]'))
                                                ],
                                                decoration: kDecoration
                                                    .inputBox('Amount', 'PKR'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This field is required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            TextFormField(
                                              maxLines: 5,
                                              autofocus: true,
                                              controller:
                                                  widget.descriptionController,
                                              keyboardType: TextInputType.text,
                                              decoration: kDecoration.inputBox(
                                                  'Description', ''),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please add a description for expense';
                                                }
                                                return null;
                                              },
                                            ),
                                            OutlinedButton(
                                                onPressed: () async {
                                                  if (widget.moneyController
                                                      .text.isNotEmpty) {
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
                                                              -int.parse(widget
                                                                  .moneyController
                                                                  .text)),
                                                      'expenses':
                                                          FieldValue.increment(
                                                              int.parse(widget
                                                                  .moneyController
                                                                  .text))
                                                    }).whenComplete(() {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'financials')
                                                          .doc('finance')
                                                          .collection(
                                                              'expenses')
                                                          .add({
                                                        'amount': int.parse(
                                                            widget
                                                                .moneyController
                                                                .text),
                                                        'time': Timestamp.now(),
                                                        'description': widget
                                                            .descriptionController
                                                            .text
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                          'financials')
                                                          .doc('finance')
                                                          .collection(
                                                          'transactions')
                                                          .add({
                                                        'amount': -int.parse(
                                                            widget
                                                                .moneyController
                                                                .text),
                                                        'time': Timestamp.now(),
                                                        'description': 'Expense : ${
                                                          widget
                                                              .descriptionController
                                                              .text
                                                        }'
                                                      });
                                                      Provider.of<DashboardView>(
                                                                  context,
                                                                  listen: false)
                                                              .dashboardData
                                                              .cashAvailable -=
                                                          int.parse(widget
                                                              .moneyController
                                                              .text);
                                                      Provider.of<DashboardView>(
                                                                  context,
                                                                  listen: false)
                                                              .dashboardData
                                                              .expenses +=
                                                          int.parse(widget
                                                              .moneyController
                                                              .text);
                                                      widget.moneyController
                                                          .clear();
                                                      widget
                                                          .descriptionController
                                                          .clear();
                                                      Navigator.pop(context);
                                                    });
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }
                                                },
                                                child:
                                                    const Text('Add Expense'))
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
                                          fontSize: Provider.of<DashboardView>(
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
        borderSide: const BorderSide(color: Color(0xFF0E1223), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF0E1223), width: 1),
      ),
    );
  }
}
