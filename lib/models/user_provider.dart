import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _uid;
  String _username = "";
  String _email;
  String _nickname;
  String _profileMessage;
  static List<String> _myPosts;
  static List<String> _bookmarkedPosts;
  static List<String> _likedPosts;
  String _profileImage;

  String get uid => _uid;

  String get username => _username;

  String get email => _email;

  String get nickname => _nickname;

  String get profileMessage => _profileMessage;

  List<String> get myPosts => _myPosts;

  List<String> get bookmarkedPosts => _bookmarkedPosts;

  List<String> get likedPosts => _likedPosts;

  String get profileImage => _profileImage;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future login() async {
    User user = FirebaseAuth.instance.currentUser;

    _uid = user.uid;

    await users
        .doc(_uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      if (documentSnapshot.exists) {
        _email = data['email'];
        _username = data['username'];
        _nickname = data['nickname'];
        _myPosts = data['my_posts'];
        _bookmarkedPosts = data['bookmarked_posts'];
        _likedPosts = data['liked_posts'];
        _profileImage = data['profile_image'];
        print('get data!');

        notifyListeners();
      } else {
        print('Document does not exist on the database');
        register(user);
      }
    });
  }

  void logout(){
    _uid = null;
    _email = null;
    _username = null;
    _nickname = null;
    _profileMessage = null;
    _myPosts = null;
    _bookmarkedPosts = null;
    _likedPosts = null;
    _profileImage = null;

    notifyListeners();
  }

  void register(User user){
    DocumentReference ref = users.doc(_uid);

    ref.set({
      'email':user.email,
      'username':user.displayName,
      'nickname':null,
      'profileMessage':null,
      'my_posts':[],
      'bookmarked_posts':[],
      'liked_posts':[],
      'profile_image':""
        })
        .then((value) => print("User Registed"))
        .catchError((error) => print("Failed to regist user: $error"));
    login();
  }

  void degister(){
    users.doc(_uid).delete()
        .then((value) => print("User Degist"))
        .catchError((error) => print("Failed to Degist user: $error"));
  }

  bool updateProfile(String nickname, String profileMessage, String imageUrl){
    users.doc(_uid)
        .update({
          'nickname': nickname,
          'profileMessage': profileMessage,
          'profile_image': imageUrl
        })
        .then((value) {
          print("Profile updated");
          _nickname = nickname;
          _profileMessage = profileMessage;
          _profileImage = profileImage;
        })
        .catchError((error) => print("Failed to update profile: $error"));
    notifyListeners();
  }

  void bookmark(String postDid) {
    _bookmarkedPosts.add(postDid);
    _bookmarkedPosts.sort();
    users.doc(_uid)
        .update({
          'bookmarked_posts': _bookmarkedPosts
        })
        .then((value) {
          print("bookmarked");
        })
        .catchError((error) => print("Failed to bookmark: $error"));
    notifyListeners();
  }

  void unbookmark(String postDid){
    _bookmarkedPosts.remove(postDid);
    users.doc(_uid)
        .update({
          'bookmarked_posts': _bookmarkedPosts
        })
        .then((value) {
          print("unbookmark");
        })
        .catchError((error) => print("Failed to unbookmark: $error"));
    notifyListeners();
  }

  bool isBookmarked(String postDid){
    bool result;

    if(_bookmarkedPosts == null){
      result = false;
    } else {
      result = _bookmarkedPosts.contains(postDid);
    }

    return result;
  }

  void like(String postDid) {
    _likedPosts.add(postDid);
    _likedPosts.sort();
    users.doc(_uid)
        .update({
      'liked_posts': _likedPosts
    })
        .then((value) {
      print("liked");
    })
        .catchError((error) => print("Failed to like: $error"));
    notifyListeners();
  }

  void unlike(String postDid){
    _likedPosts.remove(postDid);
    users.doc(_uid)
        .update({
      'liked_posts': _likedPosts
    })
        .then((value) {
      print("unlike");
    })
        .catchError((error) => print("Failed to unlike: $error"));
    notifyListeners();
  }

  bool isLiked(String postDid){
    bool result;

    if(_likedPosts == null){
      result = false;
    } else {
      result = _likedPosts.contains(postDid);
    }

    return result;
  }
}
