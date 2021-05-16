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
  int _likes;
  bool _displayAllPost = true;
  List<dynamic> _homePostList = [];
  List<dynamic> _childPostList = [];
  List<dynamic> _myPostList = [];

  String get currentDocId => _currentDocId;

  String get rootPostDID => _rootPostDID;

  String get parentPostDID => _parentPostDID;

  String get title => _title;

  String get content => _content;

  String get uid => _uid;

  String get unm => _unm;

  int get likes => _likes;

  bool get displayAllPost => _displayAllPost;

  List<dynamic> get homePostList => _homePostList;

  List<dynamic> get childPostList => _childPostList;

  List<dynamic> get myPostList => _myPostList;

  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  void changeDisplay(){
    _displayAllPost = !_displayAllPost;
    getHomePostList();
    if(_displayAllPost == true){
      print('you can see all Post now');
    }else{
      print('you can see root Post now');
    }
  }

  void setCurrentDocId(String currentDocId) {
    _currentDocId = currentDocId;
    print("set document id to $_currentDocId");

    notifyListeners();
  }

  void removeDocId(){
    _currentDocId = null;
    _rootPostDID = null;
    print("set currentDocument id to $_currentDocId");
    print("set rootDocument id to $_rootPostDID");
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
          'parentPostDID': parentPostDID,
          'likes': 0
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));

    setCurrentDocId(ref.id);
  }

  Future getPostData(String currentDocId) async {
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
        _likes = documentSnapshot.data()['likes'];
        print('get data!');
      } else {
        print('Document does not exist on the database');
      }
    });
    setCurrentDocId(currentDocId);
  }

  void updatePost(String title, String content) {
    _title = title;
    _content = content;
    posts
        .doc(_currentDocId)
        .update({'content': content, 'title': title})
        .then((value) => print("Post Updated"))
        .catchError((error) => print("Failed to update post: $error"));

    notifyListeners();
  }

  void deletePost() {
    posts
        .doc(_currentDocId)
        .delete()
        .then((value) => print("Post Delete"))
        .catchError((error) => print("Failed to delete post: $error"));

    setCurrentDocId(null);
  }

  void anonymizationPost() {
    posts
        .doc(_currentDocId)
        .update({'unm': '익명'})
        .then((value) => print("Post Anonymized"))
        .catchError((error) => print("Failed to Anonymize post: $error"));
  }

  Future getHomePostList() async{
    if(_displayAllPost == true){
      var snapshot = await posts.get();
      _homePostList = getPostList(snapshot);
    }else{
      var snapshot = await posts.where('parentPostDID', isNull: true).get();
      _homePostList = getPostList(snapshot);
    }
    print('HomePostList: $_homePostList');

    notifyListeners();
  }

  Future getChildPostList() async{
    var snapshot = await posts.where('parentPostDID', isEqualTo: _currentDocId).get();
    _childPostList = getPostList(snapshot);

    print('ChildPostList: $_childPostList');

    notifyListeners();
  }

  //2차원 데이터 _postList (id, title, content) 반환
  List<dynamic> getPostList(snapshot){
    List<dynamic> postList = [];
    List<String> tmpList = [];

    if (snapshot != null) {
      List<QueryDocumentSnapshot> docs = snapshot.docs.toList();
      for (int i = 0; i < docs.length; i++) {
        tmpList = [];

        tmpList.add(docs[i].id);
        tmpList.add(docs[i].data()['unm']);
        tmpList.add(docs[i].data()['title']);

        String cont = docs[i].data()['content'];
        if (cont.length > 25) {
          cont = cont.substring(0, 25) + '...';
        }
        tmpList.add(cont);
        postList.add(tmpList);
      }
      return postList;
    }
    return null;
  }

  Future getMyPostList(String currentUid) async {
    List<dynamic> myPostList = [];
    List<String> myTmpList = [];

    var snapshot = await posts.where("uid", isEqualTo: currentUid).get();

    if (snapshot != null) {
      List<QueryDocumentSnapshot> docs = snapshot.docs.toList();
      for (int i = 0; i < docs.length; i++) {
        myTmpList = [];

        myTmpList.add(docs[i].id);
        myTmpList.add(docs[i].data()['title']);

        String myCont = docs[i].data()['content'];
        if (myCont.length > 25) {
          myCont = myCont.substring(0, 25) + '...';
        }
        myTmpList.add(myCont);

        myPostList.add(myTmpList);

      }
    }
    _myPostList = myPostList;
    print('MyPostList: $_myPostList');

    notifyListeners();
  }

  void liked(){
    _likes += 1;
    posts.doc(_currentDocId).update({'likes':_likes})
        .then((value) => print("post is liked"))
        .catchError((error) => print("Failed to like: $error"));

    notifyListeners();
  }

  void unliked(){
    _likes -= 1;
    posts.doc(_currentDocId).update({'likes':_likes})
        .then((value) => print("post is unliked"))
        .catchError((error) => print("Failed to unlike: $error"));

    notifyListeners();
  }
}
