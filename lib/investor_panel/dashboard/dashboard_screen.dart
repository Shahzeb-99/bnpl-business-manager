// ignore_for_file: camel_case_types

import 'package:ecommerce_bnql/company_panel/pageview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../investor_panel/dashboard/amountPaid_button/amount_spend_screen.dart';
import '../../investor_panel/dashboard/outstandingAmount_button/outstanding_balance_screen.dart';
import '../../investor_panel/view_model/viewmodel_dashboard.dart';

enum DashboardFilterOptions { all, oneMonth, sixMonths }

class DashboardInvestor extends StatefulWidget {
  const DashboardInvestor({Key? key}) : super(key: key);

  @override
  State<DashboardInvestor> createState() => _DashboardInvestorState();
}

class _DashboardInvestorState extends State<DashboardInvestor> {
  bool loading = false;
  final TextEditingController moneyController = TextEditingController();
  int filterIndex = 0;

  @override
  void initState() {
    Provider.of<DashboardViewInvestor>(context, listen: false).option =
        DashboardFilterOptions.all;
    Provider.of<DashboardViewInvestor>(context, listen: false)
        .getAllFinancials();
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
              'Dashboard Investor',
              style: TextStyle(fontSize: 25),
            ),
            loading != true
                ? IconButton(
                    splashRadius: 25,
                    onPressed: () async {
                      if (Provider.of<DashboardViewInvestor>(context,
                                  listen: false)
                              .option ==
                          DashboardFilterOptions.all) {
                        setState(() {
                          loading = true;
                        });
                        await Provider.of<DashboardViewInvestor>(context,
                                listen: false)
                            .getAllFinancials();
                        setState(() {
                          loading = false;
                        });
                      } else if (Provider.of<DashboardViewInvestor>(context,
                                  listen: false)
                              .option ==
                          DashboardFilterOptions.sixMonths) {
                        setState(() {
                          loading = true;
                        });
                        await Provider.of<DashboardViewInvestor>(context,
                                listen: false)
                            .getMonthlyFinancials();
                        setState(() {
                          loading = false;
                        });
                      } else if (Provider.of<DashboardViewInvestor>(context,
                                  listen: false)
                              .option ==
                          DashboardFilterOptions.oneMonth) {
                        setState(() {
                          loading = true;
                        });
                        await Provider.of<DashboardViewInvestor>(context,
                                listen: false)
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
                  'Investor Panel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),

                Expanded(child: Container()),
                OutlinedButton(
                    child: const Text('Switch to Company Account'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreenCustomer()),
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
                      Provider.of<DashboardViewInvestor>(context, listen: false)
                          .option = DashboardFilterOptions.all;
                      setState(() {
                        loading = true;
                      });
                      await Provider.of<DashboardViewInvestor>(context,
                              listen: false)
                          .getAllFinancials();
                      setState(() {
                        loading = false;
                      });
                    } else if (value == 1) {
                      setState(() {
                        loading = true;
                      });
                      Provider.of<DashboardViewInvestor>(context, listen: false)
                          .option = DashboardFilterOptions.oneMonth;

                      await Provider.of<DashboardViewInvestor>(context,
                              listen: false)
                          .getMonthlyFinancials();
                      setState(() {
                        loading = false;
                      });
                    } else {
                      setState(() {
                        loading = true;
                      });
                      Provider.of<DashboardViewInvestor>(context, listen: false)
                          .option = DashboardFilterOptions.sixMonths;

                      await Provider.of<DashboardViewInvestor>(context,
                              listen: false)
                          .getMonthlyFinancials();
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  children: {
                    0: buildSegment("All Time"),
                    1: buildSegment("This Month"),
                    2: buildSegment("Last 6 Months"),
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
                                      child: Provider.of<DashboardViewInvestor>(
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
                                                  Provider.of<DashboardViewInvestor>(
                                                          context)
                                                      .dashboardData
                                                      .totalOutstandingBalance
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: Provider.of<
                                                                          DashboardViewInvestor>(
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
                                                  Provider.of<DashboardViewInvestor>(
                                                          context)
                                                      .monthlyFinancials
                                                      .totalOutstandingBalance
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: Provider.of<
                                                                          DashboardViewInvestor>(
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
                                    child: Provider.of<DashboardViewInvestor>(
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
                                                Provider.of<DashboardViewInvestor>(
                                                        context)
                                                    .dashboardData
                                                    .totalAmountPaid
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: Provider.of<
                                                                        DashboardViewInvestor>(
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
                                                Provider.of<DashboardViewInvestor>(
                                                        context)
                                                    .monthlyFinancials
                                                    .totalAmountPaid
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: Provider.of<
                                                                        DashboardViewInvestor>(
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
                                  child: Provider.of<DashboardViewInvestor>(
                                                  context)
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
                                              Provider.of<DashboardViewInvestor>(
                                                      context)
                                                  .dashboardData
                                                  .totalCost
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      Provider.of<DashboardViewInvestor>(
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
                                              Provider.of<DashboardViewInvestor>(
                                                      context)
                                                  .monthlyFinancials
                                                  .totalCost
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      Provider.of<DashboardViewInvestor>(
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
                              child: Provider.of<DashboardViewInvestor>(context)
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
                                          Provider.of<DashboardViewInvestor>(
                                                  context)
                                              .dashboardData
                                              .profit
                                              .toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  Provider.of<DashboardViewInvestor>(
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
                                          '${Provider.of<DashboardViewInvestor>(context).monthlyFinancials.profit}',
                                          style: TextStyle(
                                              fontSize:
                                                  Provider.of<DashboardViewInvestor>(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'Total Investment',
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
                                      Provider.of<DashboardViewInvestor>(
                                              context)
                                          .dashboardData
                                          .cashAvailable
                                          .toString(),
                                      style: TextStyle(
                                          fontSize:
                                              Provider.of<DashboardViewInvestor>(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'Company Profit',
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
                                      Provider.of<DashboardViewInvestor>(
                                              context)
                                          .dashboardData
                                          .company_profit
                                          .toString(),
                                      style: TextStyle(
                                          fontSize:
                                              Provider.of<DashboardViewInvestor>(
                                                              context)
                                                          .dashboardData
                                                          .company_profit <
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

  Widget buildSegment(String text) {
    return Text(
      text,
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