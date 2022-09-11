import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/model/vendors.dart';
import 'package:flutter/foundation.dart';

class VendorView extends ChangeNotifier {
  List<Vendors> allVendors = [];

  void getVendors() async {
    allVendors = [];
    final cloud = FirebaseFirestore.instance;
    await cloud.collection('vendors').get().then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var vendor in value.docs) {
            Vendors newVendor = Vendors(
              name: vendor.get('name'),
              image: vendor.get('image'),
              documentID: vendor.id,
              address: vendor.get('address'),
              city: vendor.get('city'),
            );
            allVendors.add(newVendor);
            notifyListeners();
          }
        }
      },
    );
    notifyListeners();
  }
}
