import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../investor_panel/model/vendors.dart';



class VendorViewInvestor extends ChangeNotifier {
  List<Investors> allVendors = [];

  void getVendors() async {
    allVendors = [];
    final cloud = FirebaseFirestore.instance;
    await cloud.collection('investors').get().then(
      (value) async {
        if (value.docs.isNotEmpty) {
          for (var investor in value.docs) {
            Investors investors = Investors(
              name: investor.get('name'),
              openingBalance: investor.get('openingBalance'),
              currentBalance: investor.get('currentBalance'),
                investorReference: investor.reference

            );
            allVendors.add(investors);
            notifyListeners();
          }
        }
      },
    );
    notifyListeners();
  }
}
