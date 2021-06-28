import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _uid;
  String _username;
  String _email;
  String _nickname;
  String _profileMessage;
  List<String> _myPosts;
  List<String> _bookmarkedPosts;
  List<String> _likedPosts;
  String _profileImage;

  String get uid => _uid;

  String get name => _username;

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
      if (documentSnapshot.exists) {
        _email = documentSnapshot.data()['email'];
        _username = documentSnapshot.data()['username'];
        _nickname = documentSnapshot.data()['nickname'];
        _profileMessage = documentSnapshot.data()['profileMessage'];
        _myPosts = documentSnapshot.data()['my_posts'];
        _bookmarkedPosts = documentSnapshot.data()['bookmarked_posts'];
        _likedPosts = documentSnapshot.data()['liked_posts'];
        _profileImage = documentSnapshot.data()['profile_image'];
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
      'my_posts':null,
      'bookmarked_posts':null,
      'liked_posts':null,
      'profile_image':null
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
    if(nickname.length >= 1) {
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
      return true;
    } else {
      return false;
    }
  }
}
