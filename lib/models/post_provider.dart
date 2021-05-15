import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostProvider with ChangeNotifier {
  User user = FirebaseAuth.instance.currentUser;

  String _currentDocId;
  String _rootPostDID;
  String _parentPostDID;
  String _title;
  String _content;
  String _uid;
  String _unm;
  List<dynamic> _postList = [];
  List<dynamic> _myPostList = [];

  String get currentDocId => _currentDocId;

  String get rootPostDID => _rootPostDID;

  String get parentPostDID => _parentPostDID;

  String get title => _title;

  String get content => _content;

  String get uid => _uid;

  String get unm => _unm;

  List<dynamic> get postList => _postList;

  List<dynamic> get myPostList => _myPostList;

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  void setCurrentDocId(String currentDocId) {
    _currentDocId = currentDocId;
    print("set document id to $_currentDocId");
  }

  void removeCurrentDocId(){
    _currentDocId = null;
    print("set document id to $_currentDocId");
  }

  void createPost(String title, String content, String uid, String unm) {
    DocumentReference ref = posts.doc();
    String rootPostDID = _rootPostDID == null ? ref.id : _rootPostDID;
    String parentPostDID = _currentDocId;
    ref
        .set({
          'content': content,
          'title': title,
          'uid': uid,
          'unm': unm,
          'rootPostDID': rootPostDID,
          'parentPostDID': parentPostDID
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  Future getPostData(String currentDocId) async {
    setCurrentDocId(currentDocId);
    await posts
        .doc(currentDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _rootPostDID = documentSnapshot.data()['rootPostDID'];
        _parentPostDID = documentSnapshot.data()['parentPostDID'];
        _title = documentSnapshot.data()['title'];
        _content = documentSnapshot.data()['content'];
        _uid = documentSnapshot.data()['uid'];
        _unm = documentSnapshot.data()['unm'];
        print('get data!');
      } else {
        print('Document does not exist on the database');
      }
    });
    notifyListeners();
  }

  void updatePost(String title, String content) {
    _title = title;
    _content = content;
    posts
        .doc(_currentDocId)
        .update({'content': content, 'title': title})
        .then((value) => print("Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));
  }

  void deletePost() {
    posts
        .doc(_currentDocId)
        .delete()
        .then((value) => print("Post Delete"))
        .catchError((error) => print("Failed to Anonymize post: $error"));
  }

  void anonymizationPost() {
    String deleteDID = _currentDocId;
    posts
        .doc(deleteDID)
        .update({'unm': '익명'})
        .then((value) => print("Post Anonymized"))
        .catchError((error) => print("Failed to Anonymize post: $error"));
  }

  //2차원 데이터 _postList (id, title, content) 반환
  //isChildPosts
  // true = _currentDocId의 자식 게시글 _postList에 저장
  // false = 전체 게시글 _postList에 저장
  Future getPostList(bool isChildPosts) async {
    List<dynamic> postList = [];
    List<String> tmpList = [];

    List<dynamic> myPostList = [];
    List<String> myTmpList = [];

    var snapshot = isChildPosts
        ? await posts.where('parentPostDID', isEqualTo: _currentDocId).get()
        : await posts.get();

    if (snapshot != null) {
      List<QueryDocumentSnapshot> docs = snapshot.docs.toList();
      for (int i = 0; i < docs.length; i++) {
        tmpList = [];
        myTmpList = [];

        if (docs[i].data()['uid'] == user.uid) {
          myTmpList.add(docs[i].id);
          myTmpList.add(docs[i].data()['title']);

          String myCont = docs[i].data()['content'];
          if (myCont.length > 25) {
            myCont = myCont.substring(0, 25) + '...';
          }
          myTmpList.add(myCont);
          myPostList.add(myTmpList);
          _myPostList = myPostList;
        }

        tmpList.add(docs[i].id);
        tmpList.add(docs[i].data()['unm']);
        tmpList.add(docs[i].data()['title']);

        String cont = docs[i].data()['content'];
        if (cont.length > 25) {
          cont = cont.substring(0, 25) + '...';
        }
        tmpList.add(cont);
        postList.add(tmpList);
        _postList = postList;
      }
    }

    print('PostList: $_postList');
    print('MyPostList: $_myPostList');

    notifyListeners();
  }
}