import 'package:flutter/material.dart';
import 'package:ttt_project_003/editing_page.dart';

class ViewPostPage extends StatelessWidget {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditingPage()));
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0x46448AFF)
        ),
        height: 560,
        margin: EdgeInsets.all(20),
      ),
    );
  }
}