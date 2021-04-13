import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPost extends StatelessWidget{
  final String doucumentId;

  GetPost(this.doucumentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return FutureBuilder<DocumentSnapshot>(
      future: posts.doc(doucumentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasError){
          return Text('Something went wrong');
        }
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data.data();
          return Text('${data['title']} ${data['content']}');
        }
        return Text('loading');
      },
    );
  }
}
