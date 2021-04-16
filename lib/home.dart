import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/app_bar.dart';
import 'package:ttt_project_003/drawer.dart';
import 'package:ttt_project_003/posting_page.dart';
import 'package:ttt_project_003/view_post_page.dart';
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
                appBar: MyAppBar('Toward the Truth', [
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PostingPage()));
                      }),
                  SizedBox(
                    width: 10,
                  )
                ]),
                body: StreamBuilder<QuerySnapshot>(
                  stream: ref.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Container(
                      color: Colors.white,
                      child: new ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Container(
                            height: 100,
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: new ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewPostPage(docToView: document)));
                              },
                              title: new Text(document.data()['title']),
                              subtitle: new Text(document.data()['content']),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ));
          }
        },
      ),
    );
  }
}
