import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/widgets/my_progress_indicator.dart';

import 'constant/input_decor.dart';
import 'constant/material_white.dart';
import 'home.dart';
import 'models/firebase_auth_state.dart';
import 'models/gallery_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('error'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<GalleryState>(
                    create: (_) => GalleryState()),
                ChangeNotifierProvider<FirebaseAuthState>.value(
                    value: _firebaseAuthState),
              ],
              child: MaterialApp(
                theme: _themeData(),
                home: Home(),
              ),
            );
          }
          return MyProgressIndicator();
        });
  }

  ThemeData _themeData() {
    return ThemeData(
        primaryColor: white,
        scaffoldBackgroundColor: white,
        appBarTheme: AppBarTheme(elevation: 0.0),
        inputDecorationTheme: inputDecorTheme());
  }
}
