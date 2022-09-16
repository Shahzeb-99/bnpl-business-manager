import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../vendor/all_vendor_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const AllCustomersScreen()));
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
              ),SizedBox(height: 250,)
            ],
          ),
        ),
      ),
    );
  }
}
