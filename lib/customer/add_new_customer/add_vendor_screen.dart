import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/customer/add_new_customer/update_firebase_class.dart';
import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen(
      {Key? key,
      required this.customerName,
      required this.productName,
      required this.productPurchasecost})
      : super(key: key);

  final String customerName;
  final String productName;
  final int productPurchasecost;

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
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
          selectedVendor = vendorList.first;
        }
        setState(() {
          loading = true;
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController costController = TextEditingController();
    final formKey = GlobalKey<FormState>();
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFFD6EFF2),
                          value: selectedVendor,
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
                          hint: const Text('Select Vendor'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: formKey,
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
                        bool status = await UpdateFirestore(
                                productSalePrice: widget.productPurchasecost,
                                vendorName: selectedVendor,
                                customerName: widget.customerName,
                                productCost: int.parse(costController.text),
                                productName: widget.productName)
                            .addCustomer();

                        if (!mounted) return;

                        if (status) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllCustomersScreen()),
                              (route) => false);
                        }
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
