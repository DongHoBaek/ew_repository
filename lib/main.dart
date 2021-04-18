import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

import 'models/appStateManagement.dart';
import 'app.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => CurrentDocId(),
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MaterialApp(debugShowCheckedModeBanner: false, home: App());
  }
}
