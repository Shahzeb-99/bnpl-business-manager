// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import '../customer/payment_schedule_class.dart';
import '../customer/transaction_history_class.dart';
import '../dashboard/dashboard_screen.dart';


class Purchase {
  String customerID;
  DocumentReference documentReferencePurchase;
  Timestamp purchaseDate;
  var purchaseAmount;
  String vendorName;
  var sellingAmount;
  String? profitPercentage;
  var totalProfit;
  String productName;
  String productImage;
  var outstandingBalance;
  var amountPaid;
  List<PaymentSchedule> paymentSchedule = [];
  List<TransactionHistory> transactionHistory = [];
  String customerName;

  Purchase(
      {required this.customerName,
        required this.customerID,
      required this.documentReferencePurchase,
      required this.vendorName,
      required this.outstandingBalance,
      required this.amountPaid,
      required this.productName,
      required this.productImage,
      this.profitPercentage,
      required this.purchaseAmount,
      required this.sellingAmount,
      this.totalProfit,
      required this.purchaseDate});

  Future<void> getPaymentSchedule(String customerDocID) async {
    paymentSchedule = [];
    await documentReferencePurchase
        .collection('payment_schedule')
        .orderBy('date', descending: false)
        .get()
        .then((value) {
      for (var payment in value.docs) {
        var amount = payment.get('amount');
        Timestamp date = payment.get('date');
        bool isPaid = payment.get('isPaid');

        paymentSchedule.add(PaymentSchedule(
            remainingAmount: payment.get('remainingAmount'),
            amount: amount,
            isPaid: isPaid,
            date: date,
            paymentReference: payment.id,
            purchaseReference: documentReferencePurchase,
            customerdocID: customerDocID));
      }
    });
  }

  Future<void> getPaymentScheduleMonthlyOutstanding(
      String customerDocID) async {
    paymentSchedule = [];
    await documentReferencePurchase
        .collection('payment_schedule')
        .orderBy('date', descending: false)
        .where('date',
            isLessThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month + 1, 0,23,59))
        .get()
        .then((value) {
      for (var payment in value.docs) {
        var amount = payment.get('amount');
        Timestamp date = payment.get('date');
        bool isPaid = payment.get('isPaid');

        paymentSchedule.add(PaymentSchedule(
            remainingAmount: payment.get('remainingAmount'),
            amount: amount,
            isPaid: isPaid,
            date: date,
            paymentReference: payment.id,
            purchaseReference: documentReferencePurchase,
            customerdocID: customerDocID));
      }
    });
  }

  Future<void> getPaymentScheduleMonthlyRecovery(
      String customerDocID, DashboardFilterOptions option) async {
    paymentSchedule = [];
    await documentReferencePurchase
        .collection('payment_schedule')
        .orderBy('date', descending: false)
        .get()
        .then((value) async {
      for (var payment in value.docs) {
        var amount = payment.get('amount');
        Timestamp date = payment.get('date');
        bool isPaid = payment.get('isPaid');

        await payment.reference
            .collection('transactions')
            .where('date',
                isLessThanOrEqualTo: option != DashboardFilterOptions.all
                    ? DateTime(DateTime.now().year, DateTime.now().month + 1, 0,23,59)
                    : DateTime(2100))
            .get()
            .then((value) {
          num paidAmount = 0;
          for (var transaction in value.docs) {
            paidAmount += transaction.get('remainingAmount');
          }
          if (paidAmount > 0) {
            paymentSchedule.add(PaymentSchedule(
                remainingAmount: payment.get('remainingAmount'),
                amount: amount,
                isPaid: isPaid,
                date: date,
                paymentReference: payment.id,
                purchaseReference: documentReferencePurchase,
                customerdocID: customerDocID));
          }
        });
      }
    });
  }

  Future<void> getTransactionHistory(String customerDocID) async {
    transactionHistory = [];
    await documentReferencePurchase
        .collection('transaction_history')
        .orderBy('date', descending: false)
        .get()
        .then((value) {
      for (var payment in value.docs) {
        var amount = payment.get('amount');
        Timestamp date = payment.get('date');

        transactionHistory.add(TransactionHistory(amount: amount, date: date));
      }
    });
  }

  Future<void> getTransactionHistoryRecovery(
      String customerDocID, bool isThisMonth) async {
    transactionHistory = [];
    await documentReferencePurchase
        .collection('transaction_history')
        .where('date',
            isLessThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month + 1, 0,23,59))
        .where('date',
            isGreaterThanOrEqualTo: isThisMonth
                ? DateTime(DateTime.now().year, DateTime.now().month, 1,23,59)
                : DateTime(DateTime.now().year, DateTime.now().month - 5, 1,23,59))
        .orderBy('date', descending: false)
        .get()
        .then((value) {
      for (var payment in value.docs) {
        var amount = payment.get('amount');
        Timestamp date = payment.get('date');

        transactionHistory.add(TransactionHistory(amount: amount, date: date));
      }
    });
  }

  updateCustomTransaction({required int amount}) async {
    final cloud = FirebaseFirestore.instance;

    await cloud.collection('customers').doc(customerID).update({
      'outstanding_balance': FieldValue.increment(-amount),
      'paid_amount': FieldValue.increment(amount),
    });

    await documentReferencePurchase.update({
      'outstanding_balance': FieldValue.increment(-amount),
      'paid_amount': FieldValue.increment(amount),
    });
    cloud.collection('financials').doc('finance').update({
      'amount_paid': FieldValue.increment(amount),
      'outstanding_balance': FieldValue.increment(-amount),
      'cash_available': FieldValue.increment(amount),
    });


  }

  void addTransaction({required int amount, required DateTime dateTime}) {
    documentReferencePurchase.collection('transaction_history').add(
      {
        'amount': amount,
        'date': Timestamp.fromDate(dateTime),
      },
    );
    FirebaseFirestore.instance.collection('financials').doc('finance').collection('transactions').add(
      {
        'amount': amount,
        'time': Timestamp.fromDate(dateTime),
        'description':'Payment received from customer($customerID) for product($productName)'
      },
    );
  }
}
