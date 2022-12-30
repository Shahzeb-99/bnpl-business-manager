// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel/model/purchases.dart';
import 'package:ecommerce_bnql/investor_panel/model/vendors.dart';

import '../../investor_panel/dashboard/dashboard_screen.dart';

class Customers {
  Customers({required this.name, required this.image, required this.outstandingBalance, required this.paidAmount, required this.documentID});

  final String name;
  final String image;
  var outstandingBalance;
  var paidAmount;
  final String documentID;
  List<Purchase> purchases = [];

  deleteCustomer() async {
    int cost = 0;
    final cloud = FirebaseFirestore.instance;
    await cloud.collection('investorCustomers').doc(documentID).collection('purchases').get().then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var product in value.docs) {
            DocumentReference productRef = product.get('product');
            await productRef.get().then(
              (value) async {
                DocumentReference vendorReference = value.get('reference');
                await vendorReference.get().then(
                  (value) {
                    final int cost1 = value.get('price');
                    cost = cost + cost1;
                  },
                );
                vendorReference.delete();
              },
            );
            productRef.delete();
          }
        }
      },
    );
    cloud.collection('investorCustomers').doc(documentID).delete();
    cloud.collection('investorFinancials').doc('finance').update(
      {
        'amount_paid': FieldValue.increment(-paidAmount),
        'outstanding_balance': FieldValue.increment(-outstandingBalance),
        'total_cost': FieldValue.increment(-cost),
      },
    );
  }

  Future<void> getPurchases() async {
    purchases = [];
    Timestamp purchaseDate;
    final cloud = FirebaseFirestore.instance;
    DocumentReference documentReference;
    var outstandingBalance;
    var paidAmount;
    String productName = '';
    var productSellingPrice;
    var productCost;
    String productImage = '';
    String vendorName = '';
    num companyProfit;

    await cloud.collection('investorCustomers').doc(documentID).collection('purchases').get().then(
      (value) async {
        for (var purchase in value.docs) {
          List<Investors> investors = [];
          documentReference = purchase.reference;
          purchaseDate = purchase.get('purchaseDate');
          companyProfit = purchase.get('companyProfit');
          outstandingBalance = purchase.get('outstanding_balance');
          paidAmount = purchase.get('paid_amount');

          purchase.reference.collection('batchOrder').get().then((value) {
            for (var investor in value.docs) {
              investors.add(Investors(percentageInvestment: investor.get('percentage'), investorReference: investor.get('investor')));
            }
          });

          DocumentReference productReference = purchase.get('product');
          await productReference.get().then(
            (value) async {
              productName = value.get('name');
              productSellingPrice = value.get('price');
              DocumentReference vendorDocumentReference = value.get('reference');
              await vendorDocumentReference.get().then(
                (value) {
                  productCost = value.get('price');
                  productImage = value.get('image');
                },
              );
              await vendorDocumentReference.parent.parent?.get().then((value) {
                vendorName = value.get('name');
              });
            },
          );

          purchases.add(Purchase(
            investors: investors,
            isBatchOrder: true,
            customerName: name,
            companyProfit: companyProfit,
            customerID: documentID,
            purchaseDate: purchaseDate,
            vendorName: vendorName,
            outstandingBalance: outstandingBalance,
            amountPaid: paidAmount,
            productName: productName,
            productImage: productImage,
            purchaseAmount: productCost,
            sellingAmount: productSellingPrice,
            documentReferencePurchase: documentReference,

          ));
        }
      },
    );
  }

  Future<void> getAllPurchasesDashboardView() async {
    purchases = [];
    Timestamp purchaseDate;
    final cloud = FirebaseFirestore.instance;
    DocumentReference documentReference;
    var outstandingBalance;
    var paidAmount;
    String productName = '';
    var productSellingPrice;
    var productCost;
    String productImage = '';
    String vendorName = '';
    num companyProfit;
    await cloud.collection('investorCustomers').doc(documentID).collection('purchases').get().then(
      (value) async {
        for (var purchase in value.docs) {
          documentReference = purchase.reference;
          purchaseDate = purchase.get('purchaseDate');
          companyProfit = purchase.get('companyProfit');
          outstandingBalance = purchase.get('outstanding_balance');
          paidAmount = purchase.get('paid_amount');
          DocumentReference productReference = purchase.get('product');
          await productReference.get().then(
            (value) async {
              productName = value.get('name');
              productSellingPrice = value.get('price');
              DocumentReference vendorDocumentReference = value.get('reference');
              await vendorDocumentReference.get().then(
                (value) {
                  productCost = value.get('price');
                  productImage = value.get('image');
                },
              );
              await vendorDocumentReference.parent.parent?.get().then((value) {
                vendorName = value.get('name');
              });
            },
          );

          purchases.add(Purchase(
            isBatchOrder: purchase.get('batchOrder'),
            customerName: name,

            companyProfit: companyProfit,
            customerID: documentID,
            purchaseDate: purchaseDate,
            vendorName: vendorName,
            outstandingBalance: outstandingBalance,
            amountPaid: paidAmount,
            productName: productName,
            productImage: productImage,
            purchaseAmount: productCost,
            sellingAmount: productSellingPrice,
            documentReferencePurchase: documentReference,
          ));
        }
      },
    );
  }

  Future<void> getThisMonthPurchasesOutstanding() async {
    purchases = [];
    num companyProfit;
    Timestamp purchaseDate;
    final cloud = FirebaseFirestore.instance;
    DocumentReference documentReference;
    var outstandingBalance;
    var paidAmount;
    String productName = '';
    var productSellingPrice;
    var productCost;
    String productImage = '';
    String vendorName = '';

    await cloud.collection('investorCustomers').doc(documentID).collection('purchases').get().then(
      (value) async {
        for (var purchase in value.docs) {
          outstandingBalance = 0;

          await purchase.reference.collection('payment_schedule').where('date', isLessThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 23, 59)).get().then((value) {
            for (var payment in value.docs) {
              if (!payment.get('isPaid')) {
                outstandingBalance += payment.get('remainingAmount');
              }
            }
          });

          if (outstandingBalance > 0) {
            documentReference = purchase.reference;
            purchaseDate = purchase.get('purchaseDate');
            companyProfit = purchase.get('companyProfit');
            paidAmount = purchase.get('paid_amount');
            DocumentReference productReference = purchase.get('product');
            await productReference.get().then(
              (value) async {
                productName = value.get('name');
                productSellingPrice = value.get('price');
                DocumentReference vendorDocumentReference = value.get('reference');
                await vendorDocumentReference.get().then(
                  (value) {
                    productCost = value.get('price');
                    productImage = value.get('image');
                  },
                );
                await vendorDocumentReference.parent.parent?.get().then((value) {
                  vendorName = value.get('name');
                });
              },
            );

            purchases.add(Purchase(
              isBatchOrder: purchase.get('batchOrder'),
              customerName: name,

              companyProfit: companyProfit,
              customerID: documentID,
              purchaseDate: purchaseDate,
              vendorName: vendorName,
              outstandingBalance: outstandingBalance,
              amountPaid: paidAmount,
              productName: productName,
              productImage: productImage,
              purchaseAmount: productCost,
              sellingAmount: productSellingPrice,
              documentReferencePurchase: documentReference,
            ));
          }
        }
      },
    );
  }

  Future<void> getThisMonthPurchasesRecovery({required DashboardFilterOptions option}) async {
    purchases = [];
    num companyProfit;
    Timestamp purchaseDate;
    final cloud = FirebaseFirestore.instance;
    DocumentReference documentReference;
    var outstandingBalance;
    var paidAmount;
    String productName = '';
    var productSellingPrice;
    var productCost;
    String productImage = '';
    String vendorName = '';

    await cloud.collection('investorCustomers').doc(documentID).collection('purchases').get().then(
      (value) async {
        for (var purchase in value.docs) {
          outstandingBalance = 0;
          paidAmount = 0;

          await purchase.reference
              .collection('transaction_history')
              .where('date', isLessThanOrEqualTo: option != DashboardFilterOptions.all ? DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 23, 59) : DateTime(2100))
              .get()
              .then((value) {
            for (var transaction in value.docs) {
              paidAmount += transaction.get('amount');
            }
          });

          if (paidAmount > 0) {
            documentReference = purchase.reference;
            purchaseDate = purchase.get('purchaseDate');
            companyProfit = purchase.get('companyProfit');
            paidAmount = purchase.get('paid_amount');
            DocumentReference productReference = purchase.get('product');
            await productReference.get().then(
              (value) async {
                productName = value.get('name');
                productSellingPrice = value.get('price');
                DocumentReference vendorDocumentReference = value.get('reference');
                await vendorDocumentReference.get().then(
                  (value) {
                    productCost = value.get('price');
                    productImage = value.get('image');
                  },
                );
                await vendorDocumentReference.parent.parent?.get().then((value) {
                  vendorName = value.get('name');
                });
              },
            );

            purchases.add(Purchase(
              isBatchOrder: purchase.get('batchOrder'),
              customerName: name,

              companyProfit: companyProfit,
              customerID: documentID,
              purchaseDate: purchaseDate,
              vendorName: vendorName,
              outstandingBalance: outstandingBalance,
              amountPaid: paidAmount,
              productName: productName,
              productImage: productImage,
              purchaseAmount: productCost,
              sellingAmount: productSellingPrice,
              documentReferencePurchase: documentReference,
            ));
          }
        }
      },
    );
  }
}
