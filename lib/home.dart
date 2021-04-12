import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/drawer.dart';
import 'package:ttt_project_003/posting_page.dart';
import 'package:ttt_project_003/view_post_page.dart';
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
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PostingPage()));
                      },
                      child: Text(
                        '게시물 작성',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                itemCount: 10,
                itemBuilder: (context, index){
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),
                    margin: EdgeInsets.only(top: 10, right: 5, left: 5),
                    height: 100,
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPostPage()));
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
