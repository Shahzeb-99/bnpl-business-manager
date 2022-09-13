// ignore_for_file: no_leading_underscores_for_local_identifiers, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen(
      {Key? key,
      required this.customerName,
      required this.customerPurchaseamount,
      required this.ProductName,
      required this.ProductPurchasecost})
      : super(key: key);

  final String customerName;
  final int customerPurchaseamount;
  final String ProductName;
  final int ProductPurchasecost;

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  List<DropdownMenuItem<String>> vendorNames = [];
  List<String> vendorList = [];
  String selectedVendor = 'Select';
  bool loading = false;

  @override
  void initState() {
    final cloud = FirebaseFirestore.instance;
    cloud.collection('vendors').get().then(
      (value) {
        for (var vendor in value.docs) {
          final String name = vendor.get('name');
          vendorList.add(name);
          final newMenuItem = DropdownMenuItem<String>(
            value: name,
            child: Text(name),
          );
          setState(() {
            vendorNames.add(newMenuItem);
          });
        }
        loading = true;
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController costController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Vendor',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: loading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFD6EFF2),
                          borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFFD6EFF2),
                          value: vendorList.first,
                          items: vendorList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedVendor = value!;
                            });
                          },
                          hint: Text('Select Vendor'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: costController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: kDecoration.inputBox(
                                  'Purchase Amount', 'PKR'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await uploadCustomer(
                            vendorList.first,
                            widget.ProductName,
                            int.parse(costController.text),
                            widget.customerPurchaseamount,
                            widget.customerName);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const AllCustomersScreen()), (route) => false);
                      },
                      child: const Text('Next'),
                    ),
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  uploadCustomer(String vendorName, String productName, int productCost,
      int productSalePrice, String customerName) async {
    final cloud = FirebaseFirestore.instance;

    DocumentReference vendorReference;

    print(vendorName);
    final vendorQuery =
        cloud.collection('vendors').where('name', isEqualTo: vendorName);
    vendorQuery.get().then(
      (value) async {
        vendorReference = value.docs[0].reference;
        print(vendorReference);
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
        for(var i = 1;i<8;i++){

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
  }
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? const Text('PKR') : null,
      filled: true,
      fillColor: const Color(0xFFD6EFF2),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.white30, width: 1),
      ),
    );
  }
}
