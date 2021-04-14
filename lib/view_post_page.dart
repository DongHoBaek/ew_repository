import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'editing_page.dart';


class ViewPostPage extends StatelessWidget {
  DocumentSnapshot docToView;

  ViewPostPage({this.docToView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Page'),
        actions: [
          TextButton(
            child: Text('edit', style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditingPage(docToEdit: docToView,)));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0x46448AFF)
          ),
          height: 560,
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(docToView.data()['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 20
                ),),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 340,
                child: Text(docToView.data()['content'], textAlign: TextAlign.left,),
              )
            ],
          ),
        ),
      ),
    );
  }
}