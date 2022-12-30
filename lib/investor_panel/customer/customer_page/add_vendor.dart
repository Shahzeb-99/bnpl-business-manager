// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel/model/vendors.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../pageview_screen.dart';
import '../add_new_customer/update_firebase_class.dart';
import 'batch_order_widget.dart';
import 'package:collection/collection.dart';

enum Vendor { newVendor, existingVendor, batchOrder }

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen({Key? key, required this.customerName, required this.productName, required this.productPurchasecost}) : super(key: key);

  final String customerName;
  final String productName;
  final int productPurchasecost;

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  List<Investors> selectedInvestors = [];
  List<String> investorList = [];
  List<num> investorBalance = [];
  List<Investors> investorListBatchOrder = [];
  String selectedInvestor = 'Select';
  bool loading = false;
  var cashInHand = 0;
  final TextEditingController costController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController openingBalanceController = TextEditingController();
  final TextEditingController investorProfitController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? firstPaymentDate;
  DateTime? orderDate;
  List<double> numberOfPayments = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  double? selectedPayment;
  bool modalHUD = false;
  List<int> totalSelected = [];
  Vendor? _selectedVendorOption;

  @override
  void initState() {
    final cloud = FirebaseFirestore.instance;
    cloud.collection('investors').get().then(
      (value) {
        for (var investor in value.docs) {
          final String name = investor.get('name');
          investorListBatchOrder.add(Investors(investorReference: investor.reference, currentBalance: investor.get('currentBalance')));
          totalSelected.add(0);
          investorList.add(name);
          selectedInvestor = investorList.first;
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
    Future<void> _showMyDialog(String errorText) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2D2C3F),
            title: const Text('Task Failed'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(errorText),
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
          'Add Investor',
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
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(unselectedWidgetColor: const Color(0xFFE56E14), disabledColor: Colors.blue),
                        child: ListTile(
                          title: const Text('New Investor'),
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
                          ? Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: kDecoration.inputBox('Investor Name', ''),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: openingBalanceController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: kDecoration.inputBox('Opening Balance', 'PKR'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )
                          : const Divider(),
                      Theme(
                        data: Theme.of(context).copyWith(unselectedWidgetColor: const Color(0xFFE56E14), disabledColor: Colors.blue),
                        child: ListTile(
                          title: const Text('Existing Investor'),
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
                      Theme(
                        data: Theme.of(context).copyWith(unselectedWidgetColor: const Color(0xFFE56E14), disabledColor: Colors.blue),
                        child: ListTile(
                          title: const Text('Exissting Investor'),
                          leading: Radio<Vendor?>(
                            activeColor: const Color(0xFFE56E14),
                            value: Vendor.batchOrder,
                            groupValue: _selectedVendorOption,
                            onChanged: (value) {
                              setState(() {
                                selectedInvestors=[];
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SafeArea(
                                        child: Container(
                                            height: MediaQuery.of(context).size.height * 0.75,
                                            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Total : ${widget.productPurchasecost}'),
                                                      const Text(
                                                        'Add Investors',
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                      Text('Selected : ${totalSelected.sum}'),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: investorList.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return BatchOrderInvestorWidget(
                                                            investorsList: investorListBatchOrder,
                                                            index: index,
                                                            investorList: investorList,
                                                            onChanged: (int value) {
                                                              setState(() {
                                                                totalSelected[index] = value;
                                                              });
                                                              setState(() {});
                                                            },
                                                          );
                                                        }),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        int index = 0;
                                                        for (var hmm in totalSelected) {
                                                          if (totalSelected[index] > investorListBatchOrder[index].currentBalance!) {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialog(
                                                                    backgroundColor: Colors.white,
                                                                    title: const Text('Insufficient Funds'),
                                                                    content: const Text('One or more investors have insufficient funds'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text('Ok'))
                                                                    ],
                                                                  );
                                                                });
                                                            break;
                                                          }
                                                        }

                                                        if (totalSelected.sum != widget.productPurchasecost) {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  backgroundColor: Colors.white,
                                                                  title: const Text('Incomplete Form'),
                                                                  content: const Text('Selected amount should match the purchase cost'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: const Text('Ok'))
                                                                  ],
                                                                );
                                                              });
                                                        } else {
                                                          int index = 0;

                                                          for (var value in totalSelected) {
                                                            if (value > 0) {
                                                              var percentage = (totalSelected[index] / widget.productPurchasecost) * 100;
                                                              selectedInvestors.add(
                                                                Investors(investorReference: investorListBatchOrder[index].investorReference, percentageInvestment: percentage.toInt()),
                                                              );
                                                            }

                                                            index++;
                                                          }
                                                          setState(() {
                                                            _selectedVendorOption = value;
                                                          });
                                                          Navigator.pop(context);

                                                        }
                                                      },
                                                      child: const Text('Add Investors'))
                                                ],
                                              ),
                                            )),
                                      );
                                    });
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.grey.shade200,
                              value: selectedInvestor,
                              items: investorList.map((String items) {
                                return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: const TextStyle(
                                        color: Color(0xFFE56E14),
                                      ),
                                    ));
                              }).toList(),
                              onChanged: _selectedVendorOption == Vendor.existingVendor
                                  ? (value) {
                                      setState(() {
                                        selectedInvestor = value!;
                                      });
                                    }
                                  : null,
                              hint: const Text('Select Investor'),
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
                                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                          height: 60,
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                          child: firstPaymentDate == null
                                              ? const Text(
                                                  'First Payment Date',
                                                  textAlign: TextAlign.start,
                                                )
                                              : Text('${firstPaymentDate?.day}-${firstPaymentDate?.month}-${firstPaymentDate?.year}'),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            firstPaymentDate = await showDatePicker(
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
                                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                          height: 60,
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                          child: orderDate == null
                                              ? const Text(
                                                  'Order Date',
                                                  textAlign: TextAlign.start,
                                                )
                                              : Text('${orderDate?.day}-${orderDate?.month}-${orderDate?.year}'),
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
                                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<double>(
                                        dropdownColor: Colors.grey.shade200,
                                        value: selectedPayment,
                                        items: numberOfPayments.map((double items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items.toInt().toString(),
                                              style: const TextStyle(
                                                color: Color(0xFFE56E14),
                                              ),
                                            ),
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
                                  controller: investorProfitController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: kDecoration.inputBox('Investor Profit Percentage', '%'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    } else if (int.parse(investorProfitController.text) > 100) {
                                      return 'Percentage should not be greater than 100';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: costController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: kDecoration.inputBox('Purchase Amount', 'PKR'),
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
                            bool hasEnoughBalance = false;
                            if (_selectedVendorOption != Vendor.batchOrder) {
                              await FirebaseFirestore.instance.collection('investors').where('name', isEqualTo: selectedInvestor).get().then((value) {
                                num currentBalance = value.docs[0].get('currentBalance');
                              
                                int companyProfit = ((widget.productPurchasecost - int.parse(costController.text)) -
                                        (widget.productPurchasecost - int.parse(costController.text)) * (double.parse(investorProfitController.text) / 100))
                                    .toInt();
                              
                                if (int.parse(costController.text) + (companyProfit) <= currentBalance) {
                                  hasEnoughBalance = true;
                                }
                              });
                            }
                            setState(() {
                              modalHUD = true;
                            });

                            if (formKey.currentState!.validate()) {
                              if (hasEnoughBalance == true||_selectedVendorOption == Vendor.batchOrder) {
                                if (selectedPayment != null || firstPaymentDate != null || orderDate != null) {
                                  print('1');
                                  print(_selectedVendorOption);
                                  bool status = _selectedVendorOption == Vendor.existingVendor
                                      ? await UpdateFirestore(
                                      investorList: [],
                                              investorProfitPercentage: double.parse(investorProfitController.text),
                                              numberOfPayments: selectedPayment!,
                                              orderDate: orderDate!,
                                              productSalePrice: widget.productPurchasecost,
                                              vendorName: nameController.text.isNotEmpty ? nameController.text : 'No Name',
                                              customerName: widget.customerName,
                                              productCost: int.parse(costController.text),
                                              productName: widget.productName,
                                              firstPaymnetDate: firstPaymentDate!,
                                              openingBalance: _selectedVendorOption == Vendor.newVendor ? int.parse(openingBalanceController.text) : 0,
                                              investorName: selectedInvestor)
                                          .addProduct()
                                      : _selectedVendorOption == Vendor.newVendor
                                          ? await UpdateFirestore(
                                      investorList: [],
                                                  investorProfitPercentage: double.parse(investorProfitController.text),
                                                  numberOfPayments: selectedPayment!,
                                                  orderDate: orderDate!,
                                                  productSalePrice: widget.productPurchasecost,
                                                  vendorName: nameController.text,
                                                  customerName: widget.customerName,
                                                  productCost: int.parse(costController.text),
                                                  productName: widget.productName,
                                                  firstPaymnetDate: firstPaymentDate!,
                                                  openingBalance: int.parse(openingBalanceController.text),
                                                  investorName: nameController.text)
                                              .addProductToNewVendor()
                                          : await UpdateFirestore(
                                    investorList: selectedInvestors,
                                      investorProfitPercentage: double.parse(investorProfitController.text),
                                      numberOfPayments: selectedPayment!,
                                      orderDate: orderDate!,
                                      productSalePrice: widget.productPurchasecost,
                                      vendorName: nameController.text,
                                      customerName: widget.customerName,
                                      productCost: int.parse(costController.text),
                                      productName: widget.productName,
                                      firstPaymnetDate: firstPaymentDate!,
                                      openingBalance: 0,
                                      investorName: nameController.text)
                                      .addProducsssst(selectedInvestors);

                                  if (!mounted) return;

                                  if (status) {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
                                  } else {
                                    _showMyDialog('All the field are required to continue.');
                                  }
                                } else {
                                  _showMyDialog('All the field are required to continue.');
                                }
                              } else {
                                _showMyDialog('Investor does not have enough cash');
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
