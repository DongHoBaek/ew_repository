import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/app_bar.dart';

class MyPage extends StatelessWidget {
  final ref = FirebaseFirestore.instance.collection('posts');
  final String uid;

  MyPage(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar('MyPage', []),
        body: StreamBuilder<QuerySnapshot>(
            stream: ref.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return Container(
                color: Colors.white,
                child: new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    if (document.data()['uid'] == uid) {
                      return Container(
                        height: 100,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: new ListTile(
                          onTap: () {},
                          title: new Text(
                              '${document.data()['unm']}\n${document.data()['title']}'),
                          subtitle: new Text(document.data()['content']),
                        ),
                      );
                    }else{
                      return Container();
                    }
                  }).toList(),
                ),
              );
            }));
  }
}
