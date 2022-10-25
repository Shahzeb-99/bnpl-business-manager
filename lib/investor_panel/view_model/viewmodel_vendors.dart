import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../investor_panel/model/vendors.dart';



class VendorViewInvestor extends ChangeNotifier {
  List<Vendors> allVendors = [];

  void getVendors() async {
    allVendors = [];
    final cloud = FirebaseFirestore.instance;
    await cloud.collection('investorVendors').get().then(
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
