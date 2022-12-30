import 'package:cloud_firestore/cloud_firestore.dart';

import '../../investor_panel/model/expenses.dart';

class Investors {
  Investors(
      { this.batchOrder,
        this.percentageInvestment,
        this.companyProfit,
        this.investorReference,
        this.openingBalance,
        this.name,
        this.currentBalance,
        this.outstandingBalance,
       this.amountPaid});
  bool? batchOrder;
  int? percentageInvestment;
num? outstandingBalance;
  List<Expenses> expensesList = [];
  final String? name;
  num? amountPaid;
  num? currentBalance;
  num? openingBalance;
  num? companyProfit;
  DocumentReference? investorReference;

  getTransactions() async {
    expensesList = [];
    await investorReference
        ?.collection('transactions')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var expense in value.docs) {
        expensesList.add(Expenses(
            amount: expense.get('amount'),
            date: expense.get('date'),
            description: expense.get('description')));
      }
    });
  }

  addTransaction(
      {required int amount,
      required String description,
      required Timestamp date}) {
    currentBalance = currentBalance!+ amount;
    investorReference
        ?.collection('transactions')
        .add({'date': date, 'amount': amount, 'description': description});
  }
}
