import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/drawer.dart';
import 'package:ttt_project_003/posting_page.dart';
import 'login.dart';

class Home extends StatelessWidget {
  final ref = FirebaseFirestore.instance.collection('posts');

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
                body: StreamBuilder<QuerySnapshot>(
                  stream: ref.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return Container(
                          height: 100,
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[400],
                          ),
                          child: new ListTile(
                            onTap: (){

                            },
                            title: new Text(document.data()['title']),
                            subtitle: new Text(document.data()['content']),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ));
          }
        },
      ),
    );
  }
}
