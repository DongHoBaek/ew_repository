import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _uid;
  String _username = "";
  String _email;
  String _nickname;
  List<String> _myPosts;
  List<String> _bookmarkedPosts;
  List<String> _likedPosts;
  String _profileImage;

  String get uid => _uid;

  String get name => _username;

  String get email => _email;

  String get nickname => _nickname;

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
      'my_posts':null,
      'bookmarked_posts':null,
      'liked_posts':null,
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

  bool updateProfile(String nickname, String imageUrl){
    if(nickname.length >= 1) {
      users.doc(_uid)
          .update({'nickname': nickname, 'profile_image': imageUrl})
          .then((value) => print("Profile updated"))
          .catchError((error) => print("Failed to update profile: $error"));
      return true;
    } else {
      return false;
    }
  }
}
