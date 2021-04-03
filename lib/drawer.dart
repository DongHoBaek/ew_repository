import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {

  AsyncSnapshot<User> userSnapshot;

  MyDrawer(AsyncSnapshot<User> snapshot){
    this.userSnapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[100],
        child: ListView(
          children: [
            ListTile(
              tileColor: Colors.grey[350],
              title: Text('${userSnapshot.data.displayName}'),
              subtitle: Text('안녕하세요'),
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              onTap: (){FirebaseAuth.instance.signOut();},
              title: Text('로그아웃'),
            )
          ],
        ),
      ),
    );
  }
}