import 'package:flutter/material.dart';

class UserHomePage extends Page {
  static final String pageName = 'UserHomePage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => UserHome());
  }
}

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'MyPage',
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}

// class MyPage extends StatelessWidget {
//   final ref = FirebaseFirestore.instance.collection('posts');
//   final String uid;
//
//   MyPage(this.uid);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder<QuerySnapshot>(
//             stream: ref.snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasError) {
//                 return Center(child: Text('Something went wrong'));
//               }
//
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               return Container(
//                 color: Colors.white,
//                 child: new ListView(
//                   children: snapshot.data.docs.map((DocumentSnapshot document) {
//                     if (document.data()['uid'] == uid) {
//                       return Container(
//                         height: 100,
//                         margin: EdgeInsets.only(top: 10, left: 10, right: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey[200],
//                         ),
//                         child: new ListTile(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         ViewPostPage(uid, document.data()['unm'], docToView: document)))
//                                 .then((value)=>Provider.of<CurrentDocId>(context, listen: false).setCurrentDocId(null));
//                           },
//                           title: new Text(
//                               '${document.data()['unm']}\n${document.data()['title']}', overflow: TextOverflow.ellipsis),
//                           subtitle: new Text(document.data()['content'], overflow: TextOverflow.ellipsis),
//                         ),
//                       );
//                     }else{
//                       return Container();
//                     }
//                   }).toList(),
//                 ),
//               );
//             }));
//   }
// }
