import 'package:cloud_firestore/cloud_firestore.dart';

class AddPost {
  final String title;
  final String content;
  final String uid;

  AddPost(this.title, this.content, this.uid);

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> addPost() {
    // Call the user's CollectionReference to add a new post
    return posts
        .add({
          'content': content,
          'title': title,
          'uid': uid
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }
}