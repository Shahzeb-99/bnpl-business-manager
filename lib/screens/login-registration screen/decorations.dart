// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class kDecoration {
  static InputDecoration inputBox(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.teal.shade200,
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
