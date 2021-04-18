import 'package:cloud_firestore/cloud_firestore.dart';

class AddPost {
  final String title;
  final String content;
  final String uid;
  final String unm;
  String rootPostDID;
  final String parentPostDID;

  AddPost(this.title, this.content, this.uid, this.unm, this.rootPostDID, this.parentPostDID);

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> addPost() {
    DocumentReference ref = posts.doc();
    rootPostDID = rootPostDID == null ? ref.id : rootPostDID;
    // Call the user's CollectionReference to add a new post
    return ref
        .set({'content': content, 'title': title, 'uid': uid, 'unm': unm, 'rootPostDID':rootPostDID, 'parentPostDID':parentPostDID})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }
}
