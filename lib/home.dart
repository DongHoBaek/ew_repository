import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/drawer.dart';
import 'login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return LoginWidget();
          } else {
            return Scaffold(
              drawer: MyDrawer(snapshot),
              appBar: AppBar(
                backgroundColor: Colors.grey[600],
                title: Text('Toward the Truth'),
              ),
              body: Center(
                child: Column(

                ),
              ),
            );
          }
        },
      ),
    );
  }
}
