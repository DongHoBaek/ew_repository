import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _uid;
  String _username = "";
  String _email;
  String _nickname;
  String _profileMessage;
  static List _myPosts;
  static List _bookmarkedPosts = [];
  static List _likedPosts;
  String _profileImage;

  String get uid => _uid;

  String get username => _username;

  String get email => _email;

  String get nickname => _nickname;

  String get profileMessage => _profileMessage;

  List get myPosts => _myPosts;

  List get bookmarkedPosts => _bookmarkedPosts;

  List get likedPosts => _likedPosts;

  String get profileImage => _profileImage;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future login() async {
    User user = FirebaseAuth.instance.currentUser;

    _uid = user.uid;

    await users.doc(_uid).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (documentSnapshot.exists) {
        _email = data['email'];
        _username = data['username'];
        _nickname = data['nickname'];
        _myPosts = data['my_posts'];
        _bookmarkedPosts = data['bookmarked_posts'];
        _likedPosts = data['liked_posts'];
        _profileImage = data['profile_image'];
        print('get user data!');
        print(_bookmarkedPosts);

        notifyListeners();
      } else {
        print('Document does not exist on the database');
        register(user);
      }
    });
  }

  void logout() {
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

  void register(User user) {
    DocumentReference ref = users.doc(_uid);

    ref
        .set({
          'email': user.email,
          'username': user.displayName,
          'nickname': null,
          'profileMessage': null,
          'my_posts': [],
          'bookmarked_posts': [],
          'liked_posts': [],
          'profile_image': ""
        })
        .then((value) => print("User Registed"))
        .catchError((error) => print("Failed to regist user: $error"));
    login();
  }

  void degister() {
    users
        .doc(_uid)
        .delete()
        .then((value) => print("User Degist"))
        .catchError((error) => print("Failed to Degist user: $error"));
  }

  bool updateProfile(String nickname, String profileMessage, String imageUrl) {
    users.doc(_uid).update({
      'nickname': nickname,
      'profileMessage': profileMessage,
      'profile_image': imageUrl
    }).then((value) {
      print("Profile updated");
      _nickname = nickname;
      _profileMessage = profileMessage;
      _profileImage = profileImage;
    }).catchError((error) => print("Failed to update profile: $error"));
    notifyListeners();
  }

  void bookmark(String postDid) {
    print(postDid);
    _bookmarkedPosts.insert(0, postDid);
    print(_bookmarkedPosts);

    users
        .doc(_uid)
        .update({'bookmarked_posts': _bookmarkedPosts}).then((value) {
      print("bookmarked");
    }).catchError((error) => print("Failed to bookmark: $error"));
    notifyListeners();
  }

  void unbookmark(String postDid) {
    print(postDid);
    _bookmarkedPosts.remove(postDid);
    print(_bookmarkedPosts);
    users
        .doc(_uid)
        .update({'bookmarked_posts': _bookmarkedPosts}).then((value) {
      print("unbookmark");
    }).catchError((error) => print("Failed to unbookmark: $error"));
    notifyListeners();
  }

  bool isBookmarked(String postDid) {
    bool result = false;
      if(_bookmarkedPosts != null) {
        result = _bookmarkedPosts.contains(postDid);
      }
      return result;
  }

  void like(String postDid) {
    print(postDid);
    _likedPosts.insert(0, postDid);
    print(_likedPosts);

    users
        .doc(_uid)
        .update({'liked_posts': _likedPosts}).then((value) {
      print("liked");
    }).catchError((error) => print("Failed to like: $error"));
    notifyListeners();
  }

  void unlike(String postDid) {
    print(postDid);
    _likedPosts.remove(postDid);
    print(_likedPosts);
    users
        .doc(_uid)
        .update({'liked_posts': _likedPosts}).then((value) {
      print("unlike");
    }).catchError((error) => print("Failed to unlike: $error"));
    notifyListeners();
  }

  bool isLiked(String postDid) {
    bool result = false;
    if(_likedPosts != null) {
      result = _likedPosts.contains(postDid);
    }
    return result;
  }
}
