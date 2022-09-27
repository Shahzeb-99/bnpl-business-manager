import 'package:ecommerce_bnql/customer/customer_page/add_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> profitPercentage = ['5', '10', '15', '20', '25'];

class AddProductScreen extends StatefulWidget {
  AddProductScreen({
    Key? key,
    required this.customerName,
  }) : super(key: key);

  final String customerName;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  String selectedProfit = profitPercentage.first;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black, fontSize: 25),
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

                ],
              )),
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
                  value: selectedProfit,
                  items: profitPercentage.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Row(
                        children: [
                          Text(items),
                          Text('%'),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProfit = value!;
                    });
                  },
                  hint: const Text('Select Percentage'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFD6EFF2),
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                    'Total Selling Amount : ${getTotalProfit(price: priceController.text, percentage: selectedProfit)}')),
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
                                productPurchasecost:
                                    int.parse(priceController.text),
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

int getTotalProfit({required String price, required String percentage}) {
  if (price.isNotEmpty) {
    double total =
        (int.parse(price) * (int.parse(percentage) / 100)) + int.parse(price);

    return total.toInt();
  }

  return 0;
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
