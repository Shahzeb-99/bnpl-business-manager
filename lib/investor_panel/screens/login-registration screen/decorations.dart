// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class kDecoration {
  static InputDecoration inputBox(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      hintStyle: const TextStyle(
        color: Color(0xFFE56E14),
      ),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFFE56E14),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
