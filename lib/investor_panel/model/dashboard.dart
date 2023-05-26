import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardData {
  num totalOutstandingBalance;
  num totalAmountPaid;
  num totalCost;
  num profit;
  int cashAvailable;
  int company_profit;

  DashboardData(
      {required this.company_profit,
      required this.cashAvailable,
      required this.profit,
      required this.totalAmountPaid,
      required this.totalOutstandingBalance,
      required this.totalCost});

  Future<void> getAllFinancials() async {
    totalCost = 0;
    totalOutstandingBalance = 0;
    totalAmountPaid = 0;
    company_profit = 0;

    final cloud = FirebaseFirestore.instance;

    await cloud.collection('investorFinancials').get().then((value) {
      if (value.docs.isNotEmpty) {
        totalOutstandingBalance = value.docs[0].get('outstanding_balance');
        totalAmountPaid = value.docs[0].get('amount_paid');
        totalCost = value.docs[0].get('total_cost');
        cashAvailable = value.docs[0].get('cash_available');
        company_profit = value.docs[0].get('companyProfit');
        profit = value.docs[0].get('total_profit');
      }
    });
  }

  Future<void> getMonthlyFinancials({required bool isThisMonth}) async {
    // outstandingBalance = 0;
    // amount_paid = 0;
    totalOutstandingBalance = 0;
    totalAmountPaid = 0;
    profit = 0;
    num amountPaidMonthly = 0;
    num outstandingBalanceMonthly = 0;
    totalCost = 0;
    final cloud = FirebaseFirestore.instance;

    await cloud.collection('investorCustomers').get().then(
      (value) {
        for (var customer in value.docs) {
          customer.reference
              .collection('purchases')
              .where('purchaseDate',
                  isLessThanOrEqualTo: DateTime(
                      DateTime.now().year, DateTime.now().month + 1, 0,23,59))
              .where('purchaseDate',
                  isGreaterThanOrEqualTo: isThisMonth
                      ? DateTime(DateTime.now().year, DateTime.now().month, 1,0,0)
                      : DateTime(
                          DateTime.now().year, DateTime.now().month - 5, 1,0,0))
              .get()
              .then((value) {
            for (var purchase in value.docs) {
              outstandingBalanceMonthly += purchase.get('outstanding_balance');
              amountPaidMonthly += purchase.get('paid_amount');
              DocumentReference product = purchase.get('product');
              product.get().then(
                (value) {
                  DocumentReference vendorProductRef = value.get('reference');
                  vendorProductRef.get().then(
                    (value) {
                      totalCost += value.get('price');
                      profit = outstandingBalanceMonthly +
                          amountPaidMonthly -
                          totalCost;
                    },
                  );
                },
              );
            }
          });
        }
      },
    );
  }

  Future<void> getThisMonthCustomers(
      {required bool isThisMonth, required Function update}) async {
    totalOutstandingBalance = 0;
    totalAmountPaid = 0;

    final cloud = FirebaseFirestore.instance;
    cloud.settings.persistenceEnabled;

    await cloud.collection('investorCustomers').get().then((value) async {
      for (var customers in value.docs) {
        async(customers: customers, isThisMonth: isThisMonth, update: update);
      }
    });
  }

  Future<void> async(
      {required QueryDocumentSnapshot customers,
      required bool isThisMonth,
      required Function update}) async {
    await customers.reference.collection('purchases').get().then(
      (value) async {
        for (var purchase in value.docs) {
          await purchase.reference
              .collection('payment_schedule')
              .where('date',
                  isLessThanOrEqualTo: DateTime(
                      DateTime.now().year, DateTime.now().month + 1, 0,23,59))
              .get()
              .then((value) {
            for (var payment in value.docs) {
              totalOutstandingBalance += payment.get('remainingAmount');
            }
          });
        }
        for (var purchase in value.docs) {
          await purchase.reference
              .collection('transaction_history')
              .where('date',
                  isLessThanOrEqualTo: DateTime(
                      DateTime.now().year, DateTime.now().month + 1, 0,23,59))
              .where('date',
                  isGreaterThanOrEqualTo: isThisMonth
                      ? DateTime(DateTime.now().year, DateTime.now().month, 1,0,0)
                      : DateTime(
                          DateTime.now().year, DateTime.now().month - 5, 1,0,0))
              .get()
              .then((value) {
            for (var transaction in value.docs) {
              totalAmountPaid += transaction.get('amount');


            }
          });
        }
      },
    );
    update();
  }
}
