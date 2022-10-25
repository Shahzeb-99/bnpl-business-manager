import 'package:ecommerce_bnql/investor_panel/vendor/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../company_panel/dashboard/dashboard_screen.dart';
import '../../investor_panel/customer/all_customer_screen.dart';
import '../../investor_panel/dashboard/dashboard_screen.dart';
import '../../investor_panel/view_model/viewmodel_vendors.dart';


class AllVendorScreen extends StatefulWidget {
  const AllVendorScreen({Key? key}) : super(key: key);

  @override
  State<AllVendorScreen> createState() => _AllVendorScreenState();
}

class _AllVendorScreenState extends State<AllVendorScreen> {
  final cloud = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<VendorViewInvestor>(context, listen: false).getVendors();
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


        title: const Text(
          'Vendors',
          style: TextStyle(  fontSize: 25),
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
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => DashboardInvestor()));
                  },
                  child: const Text('Dashboard'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllCustomersScreen()));
                  },
                  child: const Text('Customers'),
                ),
                Expanded(child: Container()),
                OutlinedButton(
                    child: const Text('Switch to Company Account'),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardCompany()),
                              (route) => false);
                    })
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<VendorViewInvestor>(context).allVendors.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                color: const Color(0xFF2D2C3F),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorProfile(index: index)));
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<VendorViewInvestor>(context, listen: false)
                                  .allVendors[index]
                                  .image),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Provider.of<VendorViewInvestor>(context, listen: false)
                                    .allVendors[index]
                                    .name,
                                style: kBoldText,
                              ),
                              Text(
                                Provider.of<VendorViewInvestor>(context)
                                    .allVendors[index]
                                    .address,
                                softWrap: true,
                              )
                            ],
                          ),
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
