import 'package:flutter/material.dart';

Widget MyAppBar(String title, List<Widget> actions) {
  return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      actions: actions);
}
