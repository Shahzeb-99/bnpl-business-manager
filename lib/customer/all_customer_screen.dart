import 'package:ecommerce_bnql/customer/customer_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({Key? key}) : super(key: key);

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  final cloud = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<CustomerView>(context, listen: false).getCustomers();
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
          'Customers',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      drawer: const Drawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<CustomerView>(context).allCustomers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                color: const Color(0xFFD6EFF2),
                child: InkWell(
                  splashColor: Colors.teal.shade100,
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerProfile(index: index,)));},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'profile',
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                Provider.of<CustomerView>(context, listen: false)
                                    .allCustomers[index]
                                    .image),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<CustomerView>(context, listen: false)
                                  .allCustomers[index]
                                  .name,
                              style: kBoldText,
                            ),
                            Text(
                              'Outstanding Balance : ${Provider.of<CustomerView>(context, listen: false).allCustomers[index].outstanding_balance} PKR',
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
