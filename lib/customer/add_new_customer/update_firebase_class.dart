import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateFirestore {
  String vendorName;
  String productName;
  int productCost;
  int productSalePrice;
  String customerName;

  UpdateFirestore(
      {required this.productSalePrice,
      required this.vendorName,
      required this.customerName,
      required this.productCost,
      required this.productName});

  Future<bool> addCustomer() async {
    final cloud = FirebaseFirestore.instance;

    DocumentReference vendorReference;

    final vendorQuery =
        cloud.collection('vendors').where('name', isEqualTo: vendorName);
    vendorQuery.get().then(
      (value) async {
        vendorReference = value.docs[0].reference;
        final vendorDocumentReference =
            await vendorReference.collection('products').add(
          {
            'name': productName,
            'price': productCost,
            'image':
                'https://webcolours.ca/wp-content/uploads/2020/10/webcolours-unknown.png'
          },
        );
        final productReference = await cloud.collection('products').add(
          {
            'name': productName,
            'price': productSalePrice,
            'reference': vendorDocumentReference
          },
        );
        final newCustomerReference = await cloud.collection('customers').add(
          {
            'name': customerName,
            'outstanding_balance': productSalePrice,
            'paid_amount': 0,
            'image': 'https://cdn-icons-png.flaticon.com/512/147/147144.png'
          },
        );
        final purchaseReference = await cloud
            .collection('customers')
            .doc(newCustomerReference.id)
            .collection('purchases')
            .add(
          {
            'product': productReference,
            'outstanding_balance': productSalePrice,
            'paid_amount': 0,
          },
        );

        final double productPayment = productSalePrice / 7;

        var timeNow = DateTime.now();
        timeNow = timeNow.add(const Duration(days: 30));
        for (var i = 1; i < 8; i++) {
          await cloud
              .collection('customers')
              .doc(newCustomerReference.id)
              .collection('purchases')
              .doc(purchaseReference.id)
              .collection('payment_schedule')
              .add(
            {
              'amount': productPayment.toInt(),
              'date': Timestamp.fromDate(
                DateTime.utc(timeNow.year, timeNow.month, timeNow.day),
              ),
              'isPaid': false
            },
          );
          timeNow = timeNow.add(const Duration(days: 7));
        }
      },
    );
    return true;
  }

  Future<bool> addProduct() async {
    final cloud = FirebaseFirestore.instance;

    DocumentReference vendorReference;

    final vendorQuery =
        cloud.collection('vendors').where('name', isEqualTo: vendorName);
    vendorQuery.get().then(
      (value) async {
        vendorReference = value.docs[0].reference;
        final vendorDocumentReference =
            await vendorReference.collection('products').add(
          {
            'name': productName,
            'price': productCost,
            'image':
                'https://webcolours.ca/wp-content/uploads/2020/10/webcolours-unknown.png'
          },
        );
        final productReference = await cloud.collection('products').add(
          {
            'name': productName,
            'price': productSalePrice,
            'reference': vendorDocumentReference
          },
        );

        await cloud
            .collection('customers')
            .where('name', isEqualTo: customerName)
            .get()
            .then((value) async {
          value.docs[0].reference.update(
            {
              'outstanding_balance': FieldValue.increment(productSalePrice),
            },
          );
          final purchaseReference = await cloud
              .collection('customers')
              .doc(value.docs[0].id)
              .collection('purchases')
              .add(
            {
              'product': productReference,
              'outstanding_balance': productSalePrice,
              'paid_amount': 0,
            },
          );

          final double productPayment = productSalePrice / 7;

          var timeNow = DateTime.now();
          timeNow = timeNow.add(const Duration(days: 30));
          for (var i = 1; i < 8; i++) {
            await cloud
                .collection('customers')
                .doc(value.docs[0].id)
                .collection('purchases')
                .doc(purchaseReference.id)
                .collection('payment_schedule')
                .add(
              {
                'amount': productPayment.toInt(),
                'date': Timestamp.fromDate(
                  DateTime.utc(timeNow.year, timeNow.month, timeNow.day),
                ),
                'isPaid': false
              },
            );
            timeNow = timeNow.add(const Duration(days: 7));
          }
        });
      },
    );
    return true;
  }
}
