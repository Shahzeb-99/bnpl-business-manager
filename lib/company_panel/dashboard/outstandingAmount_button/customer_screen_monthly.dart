import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bnql/company_panel/dashboard/outstandingAmount_button/purchase_widget_monthly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/viewmodel_customers.dart';
import '../../view_model/viewmodel_dashboard.dart';
import '../dashboard_screen.dart';

class CustomerProfileMonthlyOutstanding extends StatefulWidget {
  const CustomerProfileMonthlyOutstanding({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  State<CustomerProfileMonthlyOutstanding> createState() => _CustomerProfileMonthlyOutstandingState();
}

class _CustomerProfileMonthlyOutstandingState extends State<CustomerProfileMonthlyOutstanding> {
  @override
  void initState() {
    if (Provider.of<DashboardView>(context, listen: false).option !=
        DashboardFilterOptions.all) {
      Provider.of<CustomerView>(context, listen: false)
          .getMonthlyPurchasesOutstanding(widget.index);
    } else {
      Provider.of<CustomerView>(context, listen: false)
          .getAllPurchasesDashboardView(widget.index);
    }
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
              style: const TextStyle(fontSize: 25),
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
            const Center(
              child:  Text(
                'All Purchases',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                        return PurchaseWidgetMonthlyOutstanding(
                          image: Provider.of<CustomerView>(context)
                              .thisMonthCustomers[widget.index]
                              .purchases[index]
                              .productImage,
                          name: Provider.of<CustomerView>(context)
                              .thisMonthCustomers[widget.index]
                              .purchases[index]
                              .productName,
                          outstandingBalance: Provider.of<CustomerView>(context)
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
