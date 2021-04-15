import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/app_bar.dart';

import 'editing_page.dart';

class ViewPostPage extends StatefulWidget {
  DocumentSnapshot docToView;

  ViewPostPage({this.docToView});

  @override
  _ViewPostPageState createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar('View Page', [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditingPage(
                            docToEdit: widget.docToView,
                          )));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.docToView.reference
                  .delete()
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
          SizedBox(
            width: 20,
          )
        ]),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.85,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38
                ),
                borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.docToView.data()['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 330,
                  child: Text(
                    widget.docToView.data()['content'],
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
