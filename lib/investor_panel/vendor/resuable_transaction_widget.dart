// ignore_for_file: file_names


import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_vendors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReusableTransactionWidget extends StatefulWidget {
  const ReusableTransactionWidget({Key? key, required this.index, required this.investorIndex})
      : super(key: key);
final int investorIndex;
  final int index;

  @override
  State<ReusableTransactionWidget> createState() =>
      _ReusableTransactionWidgetState();
}

class _ReusableTransactionWidgetState extends State<ReusableTransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(elevation: 0,
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMMEEEEd().format(Provider.of<VendorViewInvestor>(context).allVendors[widget.investorIndex].expensesList[widget.index].date.toDate())),

                Text('Amount : ${
                    Provider.of<VendorViewInvestor>(context)
                        .allVendors[widget.investorIndex]
                        .expensesList[widget.index]
                        .amount
                        .toString()
                } PKR'),
              ],
            ),
            Text(DateFormat.jm().format(Provider.of<VendorViewInvestor>(context).allVendors[widget.investorIndex].expensesList[widget.index].date.toDate())),
            const SizedBox(height: 10,),
            Text(Provider.of<VendorViewInvestor>(context)
                .allVendors[widget.investorIndex]
                .expensesList[widget.index]
                .description)
          ],
        ),
      ),
    );
  }
}
