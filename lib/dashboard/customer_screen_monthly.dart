import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bnql/customer/customer_page/add_product.dart';
import 'package:ecommerce_bnql/dashboard/purchase_widget_monthly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/viewmodel_customers.dart';

class CustomerProfileMonthly extends StatefulWidget {
  const CustomerProfileMonthly({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<CustomerProfileMonthly> createState() => _CustomerProfileMonthlyState();
}

class _CustomerProfileMonthlyState extends State<CustomerProfileMonthly> {


  @override
  void initState() {
    Provider.of<CustomerView>(context, listen: false)
        .getMonthlyPurchases(widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              Provider.of<CustomerView>(context, listen: false)
                  .thisMonthCustomers[widget.index]
                  .name,
              style: const TextStyle(  fontSize: 25),
            ),
            Expanded(child: Container()),
            CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    Provider.of<CustomerView>(context, listen: false)
                        .thisMonthCustomers[widget.index]
                        .image)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outstanding Balance: ${Provider.of<CustomerView>(context, listen: false).thisMonthCustomers[widget.index].outstandingBalance} PKR',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Amount Paid: ${Provider.of<CustomerView>(context, listen: false).thisMonthCustomers[widget.index].paidAmount} PKR',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                const Text(
                  'All Purchases',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductScreen(
                                  customerName: Provider.of<CustomerView>(
                                          context,
                                          listen: false)
                                      .thisMonthCustomers[widget.index]
                                      .name),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_rounded)))
              ],
            ),
            const SizedBox(
              height: 10,
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Provider.of<CustomerView>(context)
                      .thisMonthCustomers[widget.index]
                      .purchases
                      .isNotEmpty
                  ? ListView.builder(
                      physics:
                          const ScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: Provider.of<CustomerView>(context)
                          .thisMonthCustomers[widget.index]
                          .purchases
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return PurchaseWidgetMonthly(
                                image: Provider.of<CustomerView>(context)
                                    .thisMonthCustomers[widget.index]
                                    .purchases[index]
                                    .productImage,
                                name: Provider.of<CustomerView>(context)
                                    .thisMonthCustomers[widget.index]
                                    .purchases[index]
                                    .productName,
                                outstandingBalance:
                                    Provider.of<CustomerView>(context)
                                        .thisMonthCustomers[widget.index]
                                        .purchases[index]
                                        .outstandingBalance,
                                amountPaid: Provider.of<CustomerView>(context)
                                    .thisMonthCustomers[widget.index]
                                    .purchases[index]
                                    .amountPaid,
                                productIndex: index,
                                index: widget.index,
                              );
                      })
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

}
