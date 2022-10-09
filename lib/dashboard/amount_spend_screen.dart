import 'package:ecommerce_bnql/customer/customer_page/customer_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllAmountSpend extends StatefulWidget {
  const AllAmountSpend({Key? key}) : super(key: key);

  @override
  State<AllAmountSpend> createState() => _AllAmountSpendState();
}

class _AllAmountSpendState extends State<AllAmountSpend> {
  @override
  void initState() {
    Provider.of<CustomerView>(context, listen: false).getCustomers();
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
              style: TextStyle(color: Colors.black, fontSize: 25),
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
            itemCount: Provider.of<CustomerView>(context).allCustomers.length,
            itemBuilder: (BuildContext context, int index) {
              return Provider.of<CustomerView>(context)
                          .allCustomers[index]
                          .paidAmount >
                      0
                  ? Card(
                      elevation: 5,
                      color: const Color(0xFFE8C8D2),
                      child: InkWell(
                        onLongPress: () {
                          {
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE8C8D2),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ElevatedButton(
                                            child:
                                                const Text('Delete Customer'),
                                            onPressed: () {
                                              Provider.of<CustomerView>(context,
                                                      listen: false)
                                                  .allCustomers[index]
                                                  .deleteCustomer();
                                              setState(() {
                                                Provider.of<CustomerView>(
                                                        context,
                                                        listen: false)
                                                    .allCustomers
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
                                      CustomerProfile(index: index)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    Provider.of<CustomerView>(context,
                                            listen: false)
                                        .allCustomers[index]
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
                                    Provider.of<CustomerView>(context,
                                            listen: false)
                                        .allCustomers[index]
                                        .name,
                                    style: kBoldText,
                                  ),
                                  Text(
                                    'Outstanding Balance : ${Provider.of<CustomerView>(context, listen: false).allCustomers[index].outstandingBalance} PKR',
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }
}

const TextStyle kBoldText = TextStyle(fontWeight: FontWeight.bold);
