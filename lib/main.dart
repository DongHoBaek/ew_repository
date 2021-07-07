import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'constant/input_decor.dart';
import 'constant/material_white.dart';
import 'home.dart';
import 'models/gallery_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GalleryState>(create: (_) => GalleryState()),
      ],
      child: MaterialApp(
        theme: _themeData(),
        home: Home(),
      ),
    );
  }

  ThemeData _themeData() {
    return ThemeData(
      primaryColor: white,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        elevation: 0.0
      ),
      inputDecorationTheme: inputDecorTheme()
    );
  }
}

