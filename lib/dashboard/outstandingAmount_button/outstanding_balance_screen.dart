import 'package:ecommerce_bnql/dashboard/outstandingAmount_button/customer_screen_monthly.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllOutstandingBalance extends StatefulWidget {
  const AllOutstandingBalance({Key? key}) : super(key: key);

  @override
  State<AllOutstandingBalance> createState() => _AllOutstandingBalanceState();
}

class _AllOutstandingBalanceState extends State<AllOutstandingBalance> {
  @override
  void initState() {
    Provider.of<CustomerView>(context, listen: false).getThisMonthCustomersOutstanding(
        option: Provider.of<DashboardView>(context, listen: false).option);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Customers',
              style: TextStyle(fontSize: 25),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount:
                Provider.of<CustomerView>(context).thisMonthCustomers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5,
                color: const Color(0xFF2D2C3F),
                child: InkWell(
                  onLongPress: () {
                    {
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                                color: Color(0xFF2D2C3F),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ElevatedButton(
                                      child: const Text('Delete Customer'),
                                      onPressed: () {
                                        Provider.of<CustomerView>(context,
                                                listen: false)
                                            .thisMonthCustomers[index]
                                            .deleteCustomer();
                                        setState(() {
                                          Provider.of<CustomerView>(context,
                                                  listen: false)
                                              .thisMonthCustomers
                                              .removeAt(index);
                                        });
                                        Navigator.pop(context);
                                      }),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomerProfileMonthlyOutstanding(index: index)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<CustomerView>(context, listen: false)
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
                                  .thisMonthCustomers[index]
                                  .name,
                              style: kBoldText,
                            ),
                            Text(
                              'Outstanding Balance : ${Provider.of<CustomerView>(context, listen: false).thisMonthCustomers[index].outstandingBalance} PKR',
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
