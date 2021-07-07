import 'package:flutter/material.dart';
import 'package:ttt_project_003/screens/auth_screen.dart';

import 'constant/screen_size.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;
    return AuthScreen();
  }
}
