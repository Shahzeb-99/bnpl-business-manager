import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/purchase_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/viewmodel_customers.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  CollectionReference? ref;
  List<PurchaseWidget> allPurchases = [];
  List<PaymentSchedule> paymentScheduleList = [];

  @override
  void initState() {
    updateProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                'John Wick',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              Expanded(child: Container()),
              Hero(
                tag: 'profile',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      Provider.of<CustomerView>(context, listen: false)
                          .allCustomers[0]
                          .image),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Outstanding Balance: ${Provider.of<CustomerView>(context, listen: false).allCustomers[0].outstandingBalance} PKR',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Amount Paid: ${Provider.of<CustomerView>(context, listen: false).allCustomers[0].paidAmount} PKR',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 5,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: allPurchases.isNotEmpty
                    ? ListView.builder(
                        itemCount: allPurchases.length,
                        itemBuilder: (BuildContext context, int index) {
                          return allPurchases[index];
                        })
                    : Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal.shade300,
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  void updateProfile() async {
    String image = '';
    String name = '';
    int outstandingBalance;
    int amountPaid;
    final cloud = FirebaseFirestore.instance;

    final purchaseCollection = await cloud
        .collection('customers')
        .doc(Provider.of<CustomerView>(context, listen: false)
            .allCustomers[widget.index]
            .documentID)
        .collection('purchases')
        .get();

    for (var purchaseDocument in purchaseCollection.docs) {
      DocumentReference ref = purchaseDocument.get('product');
     paymentScheduleList =await getPaymentSchedule(purchaseDocument.reference);


      await ref.get().then(
        (value) async {
          name = value.get('name');

          DocumentReference vendorReference = value.get('reference');

          await vendorReference.get().then((value) {
            image = value.get('image');
          });
        },
      );
      outstandingBalance = purchaseDocument.get('outstanding_balance');
      amountPaid = purchaseDocument.get('paid_amount');

      setState(
        () {
          allPurchases.add(PurchaseWidget(
              image: image,
              name: name,
              outstandingBalance: outstandingBalance,
              amountPaid: amountPaid,paymentList: paymentScheduleList,));
        },
      );
    }
  }

  Future<List<PaymentSchedule>> getPaymentSchedule(
      DocumentReference reference) async  {
    List<PaymentSchedule> listOfPayment = [];
    reference.collection('payment_schedule').get().then((value) {
      for (var payment in value.docs) {
        int amount = payment.get('amount');
        Timestamp date = payment.get('date');
        bool isPaid = payment.get('isPaid');

        listOfPayment
            .add(PaymentSchedule(amount: amount, isPaid: isPaid, date: date));
      }
    });
    return listOfPayment;
  }
}

class PaymentSchedule {
  int amount;
  Timestamp date;
  bool isPaid;

  PaymentSchedule({required this.amount, required this.date, required this.isPaid});
}
