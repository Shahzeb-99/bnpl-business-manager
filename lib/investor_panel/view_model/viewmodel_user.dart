import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserViewModel extends ChangeNotifier {
  bool readWrite = false;

  Future<void> checkPermissions() async {
    await FirebaseFirestore.instance
        .collection('authorizedUsers')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        readWrite = true;
        notifyListeners();
      } else {
        readWrite = false;
        notifyListeners();
      }
    });
  }
}
