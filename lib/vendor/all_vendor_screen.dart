import 'package:ecommerce_bnql/vendor/vendor_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_vendors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../customer/all_customer_screen.dart';
import '../dashboard/dashboard_screen.dart';

class AllVendorScreen extends StatefulWidget {
  const AllVendorScreen({Key? key}) : super(key: key);

  @override
  State<AllVendorScreen> createState() => _AllVendorScreenState();
}

class _AllVendorScreenState extends State<AllVendorScreen> {
  final cloud = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<VendorView>(context, listen: false).getVendors();
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
          'Vendors',
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
                        MaterialPageRoute(builder: (context) => const Dashboard()));
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
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<VendorView>(context).allVendors.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                color: const Color(0xFFD6EFF2),
                child: InkWell(onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorProfile(index: index)));
                },
                  splashColor: Colors.teal.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<VendorView>(context, listen: false)
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
                                Provider.of<VendorView>(context, listen: false)
                                    .allVendors[index]
                                    .name,
                                style: kBoldText,
                              ),
                              Text(
                                Provider.of<VendorView>(context)
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
