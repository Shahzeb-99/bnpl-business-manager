// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/company_panel/pageview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../add_new_customer/update_firebase_class.dart';

enum Vendor { newVendor, existingVendor }

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
  var cashInHand = 0;
  final TextEditingController costController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? firstPaymentDate;
  DateTime? orderDate;
  List<double> numberOfPayments = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  double? selectedPayment;
  bool modalHUD = false;

  Vendor? _selectedVendorOption;

  @override
  void initState() {
    final cloud = FirebaseFirestore.instance;
    cloud.collection('financials').doc('finance').get().then((value) {
      cashInHand = value.get('cash_available');
    });
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
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2D2C3F),
            title: const Text('Missing Fields'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('All the field are required to continue.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add Vendor',
          style: TextStyle(
            fontSize: 25,
            color: Color(0xFFE56E14),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: modalHUD,
        child: loading
            ? SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xFFE56E14),
                            disabledColor: Colors.blue),
                        child: ListTile(
                          title: const Text('New Vendor'),
                          leading: Radio<Vendor?>(
                            activeColor: const Color(0xFFE56E14),
                            value: Vendor.newVendor,
                            groupValue: _selectedVendorOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedVendorOption = value;
                              });
                            },
                          ),
                        ),
                      ),
                      _selectedVendorOption == Vendor.newVendor
                          ? TextFormField(
                              controller: nameController,
                              decoration:
                                  kDecoration.inputBox('Vendor Name', ''),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            )
                          : const Divider(),
                      Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: const Color(0xFFE56E14),
                            disabledColor: Colors.blue),
                        child: ListTile(
                          title: const Text('Existing Vendor'),
                          leading: Radio<Vendor?>(
                            activeColor: const Color(0xFFE56E14),
                            value: Vendor.existingVendor,
                            groupValue: _selectedVendorOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedVendorOption = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.grey.shade200,
                              value: selectedVendor,
                              items: vendorList.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged:
                                  _selectedVendorOption == Vendor.existingVendor
                                      ? (value) {
                                          setState(() {
                                            selectedVendor = value!;
                                          });
                                        }
                                      : null,
                              hint: const Text('Select Vendor'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          height: 60,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          child: firstPaymentDate == null
                                              ? const Text(
                                                  'First Payment Date',
                                                  textAlign: TextAlign.start,
                                                )
                                              : Text(
                                                  '${firstPaymentDate?.day}-${firstPaymentDate?.month}-${firstPaymentDate?.year}'),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            firstPaymentDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2050),
                                            );
                                            setState(() {
                                              orderDate;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.date_range_rounded,
                                            color: Color(0xFFE56E14),
                                          ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          height: 60,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          child: orderDate == null
                                              ? const Text(
                                                  'Order Date',
                                                  textAlign: TextAlign.start,
                                                )
                                              : Text(
                                                  '${orderDate?.day}-${orderDate?.month}-${orderDate?.year}'),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            orderDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            );
                                            setState(() {
                                              orderDate;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.date_range_rounded,
                                            color: Color(0xFFE56E14),
                                          ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<double>(
                                        dropdownColor: Colors.grey.shade200,
                                        value: selectedPayment,
                                        items: numberOfPayments
                                            .map((double items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child:
                                                Text(items.toInt().toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedPayment = newValue;
                                          });
                                        },
                                        hint: const Text(
                                          'Number of Payments',
                                          style: TextStyle(
                                            color: Color(0xFFE56E14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                    } else if (int.parse(costController.text) >
                                        cashInHand) {
                                      return 'Not enough Cash available';
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
                            setState(() {
                              modalHUD = true;
                            });
                            if (formKey.currentState!.validate()) {
                              if (selectedPayment != null ||
                                  firstPaymentDate != null ||
                                  orderDate != null) {
                                bool status = _selectedVendorOption ==
                                        Vendor.existingVendor
                                    ? await UpdateFirestore(
                                            numberOfPayments: selectedPayment!,
                                            orderDate: orderDate!,
                                            productSalePrice:
                                                widget.productPurchasecost,
                                            vendorName: selectedVendor,
                                            customerName: widget.customerName,
                                            productCost:
                                                int.parse(costController.text),
                                            productName: widget.productName,
                                            firstPaymentDate: firstPaymentDate!)
                                        .addProduct()
                                    : _selectedVendorOption == Vendor.newVendor
                                        ? await UpdateFirestore(
                                                numberOfPayments:
                                                    selectedPayment!,
                                                orderDate: orderDate!,
                                                productSalePrice:
                                                    widget.productPurchasecost,
                                                vendorName: nameController.text,
                                                customerName:
                                                    widget.customerName,
                                                productCost: int.parse(
                                                    costController.text),
                                                productName: widget.productName,
                                                firstPaymentDate:
                                                    firstPaymentDate!)
                                            .addProductToNewVendor()
                                        : false;

                                if (!mounted) return;

                                if (status) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreenCustomer()),
                                      (route) => false);
                                } else {
                                  _showMyDialog();
                                }
                              } else {
                                _showMyDialog();
                              }
                            }
                            setState(() {
                              modalHUD = false;
                            });
                          },
                          child: const Text('Next'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? const Text('PKR') : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      hintStyle: const TextStyle(
        color: Color(0xFFE56E14),
      ),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
