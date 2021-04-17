import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/my_page.dart';

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
              title: Text('${userSnapshot.data.displayName}'),
              subtitle: Text('안녕하세요'),
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
              ),
            ),
            Divider(
              color: Colors.black54,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.home_outlined),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage(userSnapshot.data.uid)));
              },
              title: Text('마이 페이지'),
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