import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/gallery_state.dart';
import 'package:ttt_project_003/models/post_provider.dart';

class UserProvider extends ChangeNotifier {
  static Map<String, dynamic> _userDataMap;
  static Map<String, dynamic> _otherUserDataMap;

  Map<String, dynamic> get otherUserDataMap => _otherUserDataMap;

  Map<String, dynamic> get userDataMap => _userDataMap;

  CollectionReference users =
      FirebaseFirestore.instance.collection(COLLECTION_USERS);

  Future<void> getUserData() async {
    User user = FirebaseAuth.instance.currentUser;

    await users.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (documentSnapshot.exists) {

        data[KEY_USERUID] = user.uid;

        _userDataMap = data;

        print('get user data!');

        notifyListeners();
      } else {
        print('Document does not exist on the database');
        _setUserData(user);
      }
    });
  }

  Future<void> _setUserData(User user) async {
    DocumentReference ref = users.doc(user.uid);

    await ref
        .set({
          KEY_EMAIL: user.email,
          KEY_USERNAME: user.displayName,
          KEY_NICKNAME: null,
          KEY_PROFILEMSG: null,
          KEY_MYPOSTS: [],
          KEY_BOOKMARKEDPOSTS: [],
          KEY_LIKEDPOSTS: [],
          KEY_PROFILEIMG: null
        })
        .then((value) => print("User Registered"))
        .catchError((error) => print("Failed to register user: $error"));

    getUserData();
  }

  Future<String> getOtherUserData(uid) async {
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (documentSnapshot.exists) {
        data[KEY_USERUID] = uid;

        _otherUserDataMap = data;

        print('get other user data!');

      } else {
        print('Document does not exist on the database');

      }
    });

    return _otherUserDataMap[KEY_NICKNAME];
  }

  Future<void> addUserPost(did) async {
    _userDataMap[KEY_MYPOSTS].add(did);

    DocumentReference ref = users.doc(_userDataMap[KEY_USERUID]);

    await ref.update({KEY_MYPOSTS: _userDataMap[KEY_MYPOSTS]}).then(
        (value) => print('MyPostList updated'));
  }

  Future<void> removeUserPost(did) async {
    _userDataMap[KEY_MYPOSTS].remove(did);

    DocumentReference ref = users.doc(_userDataMap[KEY_USERUID]);

    await ref.update({KEY_MYPOSTS: _userDataMap[KEY_MYPOSTS]}).then(
            (value) => print('MyPostList updated'));
  }

  Future<void> updateProfile(String nickname, String profileMessage) async {
    String imgUrl = await GalleryState().uploadAndDownloadUserImg();

    await users.doc(_userDataMap[KEY_USERUID]).update({
      KEY_NICKNAME: nickname,
      KEY_PROFILEMSG: profileMessage,
      KEY_PROFILEIMG: imgUrl
    }).then((value) {
      _userDataMap[KEY_NICKNAME] = nickname;
      _userDataMap[KEY_PROFILEMSG] = profileMessage;
      _userDataMap[KEY_PROFILEIMG] = imgUrl;
      print("Profile updated");
    }).catchError((error) => print("Failed to update profile: $error"));

    notifyListeners();
  }

  Future<void> bookmark(did) async {
    _userDataMap[KEY_BOOKMARKEDPOSTS].insert(0, did);
    print(_userDataMap[KEY_BOOKMARKEDPOSTS]);

    await users.doc(_userDataMap[KEY_USERUID]).update(
        {KEY_BOOKMARKEDPOSTS: _userDataMap[KEY_BOOKMARKEDPOSTS]}).then((value) {
      print("bookmarked");
    }).catchError((error) => print("Failed to bookmark: $error"));

    notifyListeners();
  }

  Future<void> unbookmark(did) async {
    _userDataMap[KEY_BOOKMARKEDPOSTS].remove(did);
    print(_userDataMap[KEY_BOOKMARKEDPOSTS]);

    await users.doc(_userDataMap[KEY_USERUID]).update(
        {KEY_BOOKMARKEDPOSTS: _userDataMap[KEY_BOOKMARKEDPOSTS]}).then((value) {
      print("unbookmarked");
    }).catchError((error) => print("Failed to unbookmark: $error"));
    notifyListeners();
  }

  bool isBookmarked(did) {
    bool result = false;
    if (_userDataMap[KEY_BOOKMARKEDPOSTS] != null) {
      result = _userDataMap[KEY_BOOKMARKEDPOSTS].contains(did);
    }
    return result;
  }

  Future<void> like(did) async {
    _userDataMap[KEY_LIKEDPOSTS].insert(0, did);
    print(_userDataMap[KEY_LIKEDPOSTS]);

    await users
        .doc(_userDataMap[KEY_USERUID])
        .update({KEY_LIKEDPOSTS: _userDataMap[KEY_LIKEDPOSTS]}).then((value) {
      print("liked");
    }).catchError((error) => print("Failed to like: $error"));

    PostProvider().liked();

    notifyListeners();
  }

  Future<void> unlike(did) async {
    _userDataMap[KEY_LIKEDPOSTS].remove(did);
    print(_userDataMap[KEY_LIKEDPOSTS]);

    await users
        .doc(_userDataMap[KEY_USERUID])
        .update({KEY_LIKEDPOSTS: _userDataMap[KEY_LIKEDPOSTS]}).then((value) {
      print("unliked");
    }).catchError((error) => print("Failed to unlike: $error"));

    PostProvider().unliked();

    notifyListeners();
  }

  bool isLiked(did) {
    bool result = false;
    if (_userDataMap[KEY_LIKEDPOSTS] != null) {
      result = _userDataMap[KEY_LIKEDPOSTS].contains(did);
    }
    return result;
  }
}
