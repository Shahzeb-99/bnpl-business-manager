import 'package:ecommerce_bnql/customer/customer_page/customer_screen.dart';
import 'package:ecommerce_bnql/dashboard/dashboard_screen.dart';
import 'package:ecommerce_bnql/vendor/all_vendor_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_new_customer/add_customer_screen.dart';

enum CustomerFilterOptions { all, oneMonth, sixMonths }

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({Key? key}) : super(key: key);

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  @override
  void initState() {
    if (Provider.of<CustomerView>(context, listen: false).option ==
        CustomerFilterOptions.all) {
      Provider.of<CustomerView>(context, listen: false).getCustomers();
    } else {
      Provider.of<CustomerView>(context, listen: false).getThisMonthCustomers();
    }

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
              ));
        }),
        title: Row(
          children: [
            const Text(
              'Customers',
              style: TextStyle(fontSize: 25),
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCustomerScreen()));
              },
              icon: const Icon(Icons.add_rounded),
              splashRadius: 25,
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      },
                      child: const Text('Dashboard'),
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
                ListTile(
                  title: const Text('All Time'),
                  leading: Radio<CustomerFilterOptions?>(
                    value: CustomerFilterOptions.all,
                    groupValue: Provider.of<CustomerView>(context).option,
                    onChanged: (value) {
                      setState(() {
                        Provider.of<CustomerView>(context, listen: false)
                            .option = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Last Month'),
                  leading: Radio<CustomerFilterOptions?>(
                    value: CustomerFilterOptions.oneMonth,
                    groupValue: Provider.of<CustomerView>(context).option,
                    onChanged: (value) {
                      setState(() {
                        Provider.of<CustomerView>(context, listen: false)
                            .option = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Last Six Months'),
                  leading: Radio<CustomerFilterOptions?>(
                    value: CustomerFilterOptions.sixMonths,
                    groupValue: Provider.of<CustomerView>(context).option,
                    onChanged: (value) {
                      setState(() {
                        Provider.of<CustomerView>(context, listen: false)
                            .option = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<CustomerView>(context, listen: false)
                        .option ==
                    CustomerFilterOptions.all
                ? Provider.of<CustomerView>(context).allCustomers.length
                : Provider.of<CustomerView>(context).thisMonthCustomers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                color: const Color(0xFF2D2C3F),
                child: InkWell(
                  onLongPress: () {
                    // {
                    //   showModalBottomSheet<void>(
                    //     backgroundColor: Colors.transparent,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return Container(
                    //         decoration: const BoxDecoration(
                    //             color: Color(0xFF2D2C3F),
                    //             borderRadius: BorderRadius.vertical(
                    //                 top: Radius.circular(20))),
                    //         height: 200,
                    //         child: Center(
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: <Widget>[
                    //               ElevatedButton(
                    //                   child: const Text('Delete Customer'),
                    //                   onPressed: () {
                    //                     Provider.of<CustomerView>(context,
                    //                             listen: false)
                    //                         .allCustomers[index]
                    //                         .deleteCustomer();
                    //                     setState(() {
                    //                       Provider.of<CustomerView>(context,
                    //                               listen: false)
                    //                           .allCustomers
                    //                           .removeAt(index);
                    //                     });
                    //                     Navigator.pop(context);
                    //                   }),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomerProfile(index: index)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<CustomerView>(context, listen: false)
                                          .option ==
                                      CustomerFilterOptions.all
                                  ? Provider.of<CustomerView>(context)
                                      .allCustomers[index]
                                      .image
                                  : Provider.of<CustomerView>(context)
                                      .thisMonthCustomers[index]
                                      .image),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<CustomerView>(context, listen: false)
                                          .option ==
                                      CustomerFilterOptions.all
                                  ? Provider.of<CustomerView>(context)
                                      .allCustomers[index]
                                      .name
                                  : Provider.of<CustomerView>(context)
                                      .thisMonthCustomers[index]
                                      .name,
                              style: kBoldText,
                            ),
                            Text(
                              'Outstanding Balance : ${Provider.of<CustomerView>(context, listen: false).option == CustomerFilterOptions.all ? Provider.of<CustomerView>(context).allCustomers[index].outstandingBalance : Provider.of<CustomerView>(context).thisMonthCustomers[index].outstandingBalance} PKR',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

const TextStyle kBoldText = TextStyle(fontWeight: FontWeight.bold);
