import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/viewmodel_customers.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  CollectionReference? ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                'John Wick',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              Expanded(child: Container()),
              Hero(
                tag: 'profile',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      Provider.of<CustomerView>(context, listen: false)
                          .allCustomers[0]
                          .image),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Outstanding Balance: ${Provider.of<CustomerView>(context).allCustomers[0].outstanding_balance} PKR',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Amount Paid: ${Provider.of<CustomerView>(context).allCustomers[0].paid_amount} PKR',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 5,
                child: Divider(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ));
  }
}
