// ignore_for_file: no_leading_underscores_for_local_identifiers, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel//customer/add_new_customer/update_firebase_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../investor_panel/customer/all_customer_screen.dart';

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
  List<double> numberOfPayments = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  double? selectedPayment;
  List<String> vendorList = [];
  String selectedVendor = 'Select';
  bool loading = false;
  var cashInHand = 0;
  final TextEditingController costController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController investorProfitController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  Vendor? _selectedVendorOption;
  DateTime? firstPaymentDate;
  DateTime? orderDate;
  bool modalHUD = false;

  @override
  void initState() {
    final cloud = FirebaseFirestore.instance;
    cloud.collection('investorFinancials').doc('finance').get().then((value) {
      cashInHand = value.get('cash_available');
    });
    cloud.collection('investorVendors').get().then(
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
          style: TextStyle(fontSize: 25),
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
                      ListTile(
                        title: const Text('New Investor'),
                        leading: Radio<Vendor?>(
                          value: Vendor.newVendor,
                          groupValue: _selectedVendorOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedVendorOption = value;
                            });
                          },
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
                      ListTile(
                        title: const Text('Existing Vendor'),
                        leading: Radio<Vendor?>(
                          value: Vendor.existingVendor,
                          groupValue: _selectedVendorOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedVendorOption = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF2D2C3F),
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: const Color(0xFF2D2C3F),
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
                                              color: const Color(0xFF2D2C3F),
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
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2050),
                                            );
                                            setState(() {
                                              orderDate;
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.date_range_rounded))
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
                                              color: const Color(0xFF2D2C3F),
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
                                              Icons.date_range_rounded))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2D2C3F),
                                        borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<double>(
                                        dropdownColor: const Color(0xFF2D2C3F),
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
                                        hint: const Text('Number of Payments'),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextFormField(
                                    controller: investorProfitController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: kDecoration.inputBox(
                                        'Investor Profit Percentage', '%'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      } else if (int.parse(
                                              investorProfitController.text) >
                                          100) {
                                        return 'Percentage should not be greater than 100';
                                      }
                                      return null;
                                    },
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
                                            investorProfitPercentage: double.parse(
                                                investorProfitController.text),
                                            numberOfPayments: selectedPayment!,
                                            orderDate: orderDate!,
                                            productSalePrice:
                                                widget.productPurchasecost,
                                            vendorName: selectedVendor,
                                            customerName: widget.customerName,
                                            productCost:
                                                int.parse(costController.text),
                                            productName: widget.productName,
                                            firstPaymnetDate: firstPaymentDate!)
                                        .addCustomerToExistingVendor()
                                    : _selectedVendorOption == Vendor.newVendor
                                        ? await UpdateFirestore(
                                                investorProfitPercentage:
                                                    double.parse(
                                                        investorProfitController
                                                            .text),
                                                numberOfPayments:
                                                    selectedPayment!,
                                                orderDate: orderDate!,
                                                productSalePrice:
                                                    widget.productPurchasecost,
                                                vendorName: nameController
                                                        .text.isNotEmpty
                                                    ? nameController.text
                                                    : 'No Name',
                                                customerName:
                                                    widget.customerName,
                                                productCost: int.parse(
                                                    costController.text),
                                                productName: widget.productName,
                                                firstPaymnetDate: firstPaymentDate!)
                                            .addCustomerToNewVendor()
                                        : false;

                                if (!mounted) return;

                                if (status) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllCustomersScreen()),
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
      suffix: suffix.isNotEmpty ? Text(suffix) : null,
      filled: true,
      fillColor: const Color(0xFF2D2C3F),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
