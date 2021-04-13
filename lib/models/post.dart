import 'package:cloud_firestore/cloud_firestore.dart';

class AddPost {
  final String title;
  final String post;

  AddPost(this.title, this.post);

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> addPost() {
    // Call the user's CollectionReference to add a new post
    return posts
        .add({
          'post': post,
          'title': title,
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }
}
