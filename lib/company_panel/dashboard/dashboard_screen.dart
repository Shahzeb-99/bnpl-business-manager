// ignore_for_file: camel_case_types
import 'package:ecommerce_bnql/investor_panel/screens/login-registration%20screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/company_panel/dashboard/expenses_screen.dart';
import 'package:ecommerce_bnql/company_panel/dashboard/transactions_screen.dart';
import 'package:ecommerce_bnql/investor_panel/pageview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../investor_panel/view_model/viewmodel_user.dart';
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
  DateTime dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

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
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFFE56E14),
                ),
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
                    backgroundColor: Colors.transparent,
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

                    child: const Text('Sign Out'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().whenComplete(() => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  LoginScreen()),
                              (route) => false));

                    }),
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
                  unselectedColor: Colors.grey.shade200,
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
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFEEAC7C),
                              )),
                          elevation: 2,
                          color: Colors.white,
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
                                          color: Colors.black,
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
                                                    color: Colors.black,
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
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ))
                                ],
                              ))),
                    ),
                    Expanded(
                      child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFEEAC7C),
                              )),
                          elevation: 2,
                          color: Colors.white,
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
                                        color: Colors.black,
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
                                                  color: Colors.black,
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
                                                  color: Colors.black,
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
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFEEAC7C),
                              )),
                          elevation: 2,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Purchase account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
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
                                                color: Colors.black,
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
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ))
                            ],
                          )),
                    ),
                    Expanded(
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFFEEAC7C),
                            )),
                        elevation: 2,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Calculative profit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
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
                                            color: Colors.black,
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
                                            color: Colors.black,
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
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFEEAC7C),
                              )),
                          elevation: 2,
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              if (Provider.of<UserViewModel>(context,
                                      listen: false)
                                  .readWrite) {
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
                                            color: Colors.white,
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
                                                        vertical: 4.0),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: TextFormField(
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
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    DateTime? newDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate: dateTime,
                                                      initialDatePickerMode:
                                                          DatePickerMode.day,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    );
                                                    setState(() {
                                                      dateTime = newDate!;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      DateFormat.yMMMMEEEEd()
                                                          .format(dateTime),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFFE56E14),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    TimeOfDay? newTime =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay
                                                                    .now());
                                                    setState(() {
                                                      time = newTime!;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      DateFormat.jms().format(
                                                          DateTime(
                                                              dateTime.year,
                                                              dateTime.month,
                                                              dateTime.day,
                                                              time.hour,
                                                              time.minute)),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFFE56E14),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
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
                                                          'time': Timestamp
                                                              .fromDate(DateTime(
                                                                  dateTime.year,
                                                                  dateTime
                                                                      .month,
                                                                  dateTime.day,
                                                                  time.hour,
                                                                  time.minute)),
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
                                        color: Colors.black,
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
                                        color: Colors.black,
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
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFEEAC7C),
                              )),
                          elevation: 2,
                          color: Colors.white,
                          child: InkWell(
                            onLongPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExpensesScreen()));
                            },
                            onTap: () {
                              if (Provider.of<UserViewModel>(context,
                                      listen: false)
                                  .readWrite) {
                                dateTime = DateTime.now();
                                time = TimeOfDay.now();
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
                                            color: Colors.white,
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
                                                        vertical: 4.0),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: TextFormField(
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
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    DateTime? newDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate: dateTime,
                                                      initialDatePickerMode:
                                                          DatePickerMode.day,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    );
                                                    setState(() {
                                                      dateTime = newDate!;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      DateFormat.yMMMMEEEEd()
                                                          .format(dateTime),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFFE56E14),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    TimeOfDay? newTime =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay
                                                                    .now());
                                                    setState(() {
                                                      time = newTime!;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      DateFormat.jms().format(
                                                          DateTime(
                                                              dateTime.year,
                                                              dateTime.month,
                                                              dateTime.day,
                                                              time.hour,
                                                              time.minute)),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFFE56E14),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
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
                                                        'expenses': FieldValue
                                                            .increment(
                                                                int.parse(widget
                                                                    .moneyController
                                                                    .text))
                                                      }).whenComplete(() {
                                                        FirebaseFirestore
                                                            .instance
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
                                                          'time': Timestamp
                                                              .fromDate(DateTime(
                                                                  dateTime.year,
                                                                  dateTime
                                                                      .month,
                                                                  dateTime.day,
                                                                  time.hour,
                                                                  time.minute)),
                                                          'description': widget
                                                              .descriptionController
                                                              .text
                                                        });

                                                        FirebaseFirestore
                                                            .instance
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
                                                          'time': Timestamp
                                                              .fromDate(DateTime(
                                                                  dateTime.year,
                                                                  dateTime
                                                                      .month,
                                                                  dateTime.day,
                                                                  time.hour,
                                                                  time.minute)),
                                                          'description':
                                                              'Expense : ${widget.descriptionController.text}'
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
                              }
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
                                        color: Colors.black,
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
                                        color: Colors.black,
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
