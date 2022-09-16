// ignore_for_file: no_leading_underscores_for_local_identifiers, camel_case_types

import 'package:ecommerce_bnql/customer/add_new_customer/add_product.dart';
import 'package:flutter/material.dart';

class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Customer',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductScreen(
                        customerName: nameController.text,
                      ),
                    ),
                  );
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
