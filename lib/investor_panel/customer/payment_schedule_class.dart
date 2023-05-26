import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel/customer/transaction_history_class.dart';


class PaymentSchedule {
  int remainingAmount;
  int amount;
  Timestamp date;
  bool isPaid;
  DocumentReference purchaseReference;
  String paymentReference;
  String customerdocID;
  List<TransactionHistory> transactionHistory = [];

  PaymentSchedule(
      {required this.remainingAmount,
      required this.paymentReference,
      required this.purchaseReference,
      required this.amount,
      required this.date,
      required this.isPaid,
      required this.customerdocID});

  void updateFirestore() async {
    purchaseReference
        .collection('payment_schedule')
        .doc(paymentReference)
        .update({
      'amount':amount,
      'date': date,
      'isPaid': isPaid,
      'remainingAmount': remainingAmount
    });
  }

  Future<void> addTransaction({required int amount,required DateTime dateTime}) async {
    if (amount>0) {
      purchaseReference
          .collection('payment_schedule')
          .doc(paymentReference).collection('transactions')
          .add({
        'date': Timestamp.fromDate(dateTime),
        'remainingAmount': amount
      });
    }
  }

  Future<void> updateBalance() async {
    final cloud = FirebaseFirestore.instance;
    cloud.collection('investorFinancials').doc('finance').update(
      {
        'outstanding_balance': isPaid
            ? FieldValue.increment(-amount)
            : FieldValue.increment(amount),
        'amount_paid': isPaid
            ? FieldValue.increment(amount)
            : FieldValue.increment(-amount),
        'cash_available': isPaid
            ? FieldValue.increment(amount)
            : FieldValue.increment(-amount),
      },
    );
    purchaseReference.update(
      {
        'outstanding_balance': isPaid
            ? FieldValue.increment(-amount)
            : FieldValue.increment(amount),
        'paid_amount': isPaid
            ? FieldValue.increment(amount)
            : FieldValue.increment(-amount),
      },
    );

    cloud.collection('investorCustomers').doc(customerdocID).update(
      {
        'outstanding_balance': isPaid
            ? FieldValue.increment(-amount)
            : FieldValue.increment(amount),
        'paid_amount': isPaid
            ? FieldValue.increment(amount)
            : FieldValue.increment(-amount),
      },
    );
  }

  Future<void> togglePayment() async {
    isPaid = !isPaid;
      updateFirestore();
    await updateBalance();
  }

  Future<void> getInstallmentTransactionHistory() async {
    transactionHistory = [];

    await purchaseReference
        .collection('payment_schedule')
        .doc(paymentReference).collection('transactions')
        .orderBy('date', descending: false)
        .get()
        .then((value) {
      for (var payment in value.docs) {
        var amount = payment.get('remainingAmount');
        Timestamp date = payment.get('date');

        transactionHistory.add(TransactionHistory(amount: amount, date: date));
      }
    });


  }
}
