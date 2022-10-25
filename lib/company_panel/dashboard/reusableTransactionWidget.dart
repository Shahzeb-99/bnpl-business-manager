// ignore_for_file: file_names

import 'package:ecommerce_bnql/company_panel/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReusableTransactionWidget extends StatefulWidget {
  const ReusableTransactionWidget({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  State<ReusableTransactionWidget> createState() =>
      _ReusableTransactionWidgetState();
}

class _ReusableTransactionWidgetState extends State<ReusableTransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2C3F),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMMEEEEd().format(Provider.of<DashboardView>(context).dashboardData.expensesList[widget.index].date.toDate())),
                Text('Amount : ${
                  Provider.of<DashboardView>(context)
                      .dashboardData
                      .expensesList[widget.index]
                      .amount
                      .toString()
                } PKR'),
              ],
            ),
            Text(Provider.of<DashboardView>(context)
                .dashboardData
                .expensesList[widget.index]
                .description)
          ],
        ),
      ),
    );
  }
}
