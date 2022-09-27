import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateFirestore {
  String vendorName;
  String productName;
  int productCost;
  int productSalePrice;
  String customerName;
  DateTime firstPaymnetDate;

  UpdateFirestore(
      {required this.productSalePrice,
      required this.vendorName,
      required this.customerName,
      required this.productCost,
      required this.productName,
        required this.firstPaymnetDate

      });

  Future<bool> addCustomerToExistingVendor() async {
    final cloud = FirebaseFirestore.instance;
    cloud.collection('financials').doc('finance').update(
      {
        'outstanding_balance': FieldValue.increment(productSalePrice),
        'total_cost': FieldValue.increment(productCost),
      },
    );

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

        var timeNow = firstPaymnetDate;
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
          timeNow = timeNow.add(const Duration(days: 30));
        }
      },
    );
    return true;
  }
  Future<bool> addCustomerToNewVendor() async {
    final cloud = FirebaseFirestore.instance;

    cloud.collection('financials').doc('finance').update(
      {
        'outstanding_balance': FieldValue.increment(productSalePrice),
        'total_cost': FieldValue.increment(productCost),
      },
    );
    cloud.collection('financials').doc('finance').update({'cash_available':FieldValue.increment(-productCost)});

    DocumentReference vendorReference;

    vendorReference = await cloud.collection('vendors').add({
      'name': vendorName,
      'address': 'Address',
      'city': 'City',
      'image': 'https://media.istockphoto.com/vectors/default-image-icon-vector-missing-picture-page-for-website-design-or-vector-id1357365823?k=20&m=1357365823&s=612x612&w=0&h=ZH0MQpeUoSHM3G2AWzc8KkGYRg4uP_kuu0Za8GFxdFc='
    });
    DocumentReference vendorDocumentReference = await vendorReference.collection('products').add(
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

        var timeNow = firstPaymnetDate;
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
          timeNow = timeNow.add(const Duration(days: 30));
        }

    return true;
  }

  Future<bool> addProduct() async {

    final cloud = FirebaseFirestore.instance;
    cloud.collection('financials').doc('finance').update({'cash_available':FieldValue.increment(-productCost)});
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
          cloud.collection('financials').doc('finance').update(
            {
              'outstanding_balance': FieldValue.increment(productSalePrice),
              'total_cost': FieldValue.increment(productSalePrice),
            },
          );

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

          var timeNow = firstPaymnetDate;
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
            timeNow = timeNow.add(const Duration(days: 30));
          }
        });
      },
    );
    return true;
  }

  Future<bool> addProductToNewVendor() async {
    

    final cloud = FirebaseFirestore.instance;

    cloud.collection('financials').doc('finance').update({'cash_available':FieldValue.increment(-productCost)});
    
    DocumentReference vendorReference;

    vendorReference = await cloud.collection('vendors').add({
      'name': vendorName,
      'address': 'Address',
      'city': 'City',
      'image': 'https://media.istockphoto.com/vectors/default-image-icon-vector-missing-picture-page-for-website-design-or-vector-id1357365823?k=20&m=1357365823&s=612x612&w=0&h=ZH0MQpeUoSHM3G2AWzc8KkGYRg4uP_kuu0Za8GFxdFc='
    });
    DocumentReference vendorDocumentReference = await vendorReference.collection('products').add(
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
      cloud.collection('financials').doc('finance').update(
        {
          'outstanding_balance': FieldValue.increment(productSalePrice),
          'total_cost': FieldValue.increment(productSalePrice),
        },
      );

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

      var timeNow = firstPaymnetDate;
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
        timeNow = timeNow.add(const Duration(days: 30));
      }
    });

    return true;
  }
}
