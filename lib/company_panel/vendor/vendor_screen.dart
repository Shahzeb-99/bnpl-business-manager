import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/company_panel/vendor/vendor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/viewmodel_vendors.dart';

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  List<VendorWidget> allProducts = [];

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
                Provider.of<VendorView>(context, listen: false)
                    .allVendors[widget.index]
                    .name,
                style: const TextStyle(  fontSize: 25),
              ),
              Expanded(child: Container()),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    Provider.of<VendorView>(context, listen: false)
                        .allVendors[0]
                        .image),
              ),
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
                child: allProducts.isNotEmpty
                    ? ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: allProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return allProducts[index];
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
    final cloud = FirebaseFirestore.instance;

    final productCollection = await cloud
        .collection('vendors')
        .doc(Provider.of<VendorView>(context, listen: false)
            .allVendors[widget.index]
            .documentID)
        .collection('products')
        .get();

    for (var productDocument in productCollection.docs) {
      setState(
        () {
          allProducts.add(VendorWidget(price: productDocument.get('price'), image: productDocument.get('image'), name: productDocument.get('name')));
        },
      );
    }
  }
}
