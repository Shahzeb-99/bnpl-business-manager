import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel/vendor/purchase_widget_vendor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../investor_panel/view_model/viewmodel_vendors.dart';

List<PurchaseWidgetVendor> purchaseWidgetList = [];

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
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
              Text(
                Provider.of<VendorViewInvestor>(context, listen: false)
                    .allVendors[widget.index]
                    .name,
                style: const TextStyle(fontSize: 25),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'All Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: purchaseWidgetList.isNotEmpty
                    ? ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: purchaseWidgetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return purchaseWidgetList[index];
                        })
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  void updateProfile() async {
    purchaseWidgetList = [];
    print('1');
    final productCollection =
        await Provider.of<VendorViewInvestor>(context, listen: false)
            .allVendors[widget.index]
            .investorReference
            .collection('products')
            .get();
    print('1');
    for (var productDocument in productCollection.docs) {
      print('2');
      DocumentReference productReference =
          productDocument.get('productReference');
      print('3');
      DocumentSnapshot product = await productReference.get();
      print('4');
      final num outstandingAmount = product.get('outstanding_balance');
      final num amountPaid = product.get('paid_amount');
      productReference = product.get('product');
      print('5');
      product = await productReference.get();
      final String name = product.get('name');

      setState(() {
        purchaseWidgetList.add(PurchaseWidgetVendor(
          image: 'https://i.stack.imgur.com/mwFzF.png',
          name: name,
          outstandingBalance: outstandingAmount,
          amountPaid: amountPaid,
        ));
      });
    }
  }
}
