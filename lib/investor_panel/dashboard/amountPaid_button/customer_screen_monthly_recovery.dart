import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bnql/investor_panel/dashboard/amountPaid_button/purchase_widget_monthly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../investor_panel/dashboard/dashboard_screen.dart';
import '../../../investor_panel/view_model/viewmodel_customers.dart';
import '../../../investor_panel/view_model/viewmodel_dashboard.dart';


class CustomerProfileMonthlyRecovery extends StatefulWidget {
  const CustomerProfileMonthlyRecovery({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  State<CustomerProfileMonthlyRecovery> createState() => _CustomerProfileMonthlyRecoveryState();
}

class _CustomerProfileMonthlyRecoveryState extends State<CustomerProfileMonthlyRecovery> {
  @override
  void initState() {
    if (Provider.of<DashboardViewInvestor>(context, listen: false).option !=
        DashboardFilterOptions.all) {
      Provider.of<CustomerViewInvestor>(context, listen: false)
          .getMonthlyPurchasesRecovery(widget.index,Provider.of<DashboardViewInvestor>(context, listen: false).option);
    } else {
      Provider.of<CustomerViewInvestor>(context, listen: false)
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
              Provider.of<CustomerViewInvestor>(context, listen: false)
                  .thisMonthCustomers[widget.index]
                  .name,
              style: const TextStyle(fontSize: 25),
            ),
            Expanded(child: Container()),
            CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    Provider.of<CustomerViewInvestor>(context, listen: false)
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
              'Outstanding Balance: ${Provider.of<CustomerViewInvestor>(context, listen: false).thisMonthCustomers[widget.index].outstandingBalance} PKR',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Amount Paid: ${Provider.of<CustomerViewInvestor>(context, listen: false).thisMonthCustomers[widget.index].paidAmount} PKR',
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
              child: Provider.of<CustomerViewInvestor>(context)
                  .thisMonthCustomers[widget.index]
                  .purchases
                  .isNotEmpty
                  ? ListView.builder(
                  physics:
                  const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: Provider.of<CustomerViewInvestor>(context)
                      .thisMonthCustomers[widget.index]
                      .purchases
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return PurchaseWidgetMonthlyRecovery(
                      image: Provider.of<CustomerViewInvestor>(context)
                          .thisMonthCustomers[widget.index]
                          .purchases[index]
                          .productImage,
                      name: Provider.of<CustomerViewInvestor>(context)
                          .thisMonthCustomers[widget.index]
                          .purchases[index]
                          .productName,
                      outstandingBalance: Provider.of<CustomerViewInvestor>(context)
                          .thisMonthCustomers[widget.index]
                          .purchases[index]
                          .outstandingBalance,
                      amountPaid: Provider.of<CustomerViewInvestor>(context)
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
