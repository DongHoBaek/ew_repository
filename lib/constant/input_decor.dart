import 'package:flutter/material.dart';

InputDecorationTheme inputDecorTheme() {
  return InputDecorationTheme(
      fillColor: Colors.grey[300],
      filled: true,
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: _activeInputBorder(),
      errorBorder: _errorInputBorder(),
      focusedBorder: _activeInputBorder(),
      focusedErrorBorder: _errorInputBorder(),
      hintStyle: TextStyle(color: Colors.black26)
  );
}

OutlineInputBorder _errorInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
    ),
  );
}

OutlineInputBorder _activeInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide.none,
  );
}
