// ignore_for_file: camel_case_types

import 'package:ecommerce_bnql/customer/customer_page/add_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
enum ProfitSelection { percentage, lumpsum }
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    Key? key,
    required this.customerName,
  }) : super(key: key);

  final String customerName;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController profitPercentageController = TextEditingController();
  final TextEditingController profitLumpsumController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ProfitSelection _selectedProfitOption = ProfitSelection.percentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(  fontSize: 25),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      autofocus: true,
                      decoration: kDecoration.inputBox('Name', ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration:
                          kDecoration.inputBox('Purchase Amount', 'PKR'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Percentage Profit'),
                    leading: Radio<ProfitSelection?>(
                      value: ProfitSelection.percentage,
                      groupValue: _selectedProfitOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedProfitOption = value!;
                        });
                      },
                    ),
                  ),
                  _selectedProfitOption == ProfitSelection.percentage
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: profitPercentageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration:
                      kDecoration.inputBox('Profit Percentage', '%'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  )
                      : const Divider(),
                  ListTile(
                    title: const Text('Lump-sum Profit'),
                    leading: Radio<ProfitSelection?>(
                      value: ProfitSelection.lumpsum,
                      groupValue: _selectedProfitOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedProfitOption = value!;
                        });
                      },
                    ),
                  ),
                  _selectedProfitOption == ProfitSelection.lumpsum
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: profitLumpsumController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration:
                      kDecoration.inputBox('Lump-sum Profit', 'PKR'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  )
                      : const Divider(),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF2D2C3F),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                    'Total Selling Amount : ${_selectedProfitOption == ProfitSelection.percentage ? getTotalPercentageProfit(price: priceController.text, percentage: profitPercentageController.text) : getTotalLumpsumProfit(price: priceController.text, profit: profitLumpsumController.text)}')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddVendorScreen(
                                productName: nameController.text,
                                productPurchasecost: _selectedProfitOption ==
                                    ProfitSelection.percentage
                                    ? getTotalPercentageProfit(
                                    price: priceController.text,
                                    percentage:
                                    profitPercentageController.text)
                                    : getTotalLumpsumProfit(
                                    price: priceController.text,
                                    profit: profitLumpsumController.text),
                                customerName: widget.customerName,
                              )));
                }
              },
              child: const Text('Next'),
            ),
          )
        ],
      ),
    );
  }
}
int getTotalPercentageProfit(
    {required String price, required String percentage}) {
  if (price.isNotEmpty && percentage.isNotEmpty) {
    double total =
        (int.parse(price) * (int.parse(percentage) / 100)) + int.parse(price);

    return total.toInt();
  }

  return 0;
}

int getTotalLumpsumProfit({required String price, required String profit}) {
  if (price.isNotEmpty && profit.isNotEmpty) {
    int total = int.parse(price) + int.parse(profit);

    return total;
  }

  return 0;
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? Text(suffix) : null,
      filled: true,
      fillColor:const Color(0xFF2D2C3F),
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
