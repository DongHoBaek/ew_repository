import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/gallery_state.dart';

class UserProvider extends ChangeNotifier {
  static String _uid;
  static String _username = "";
  static String _email;
  static String _nickname;
  static String _profileMessage;
  static List _myPosts;
  static List _bookmarkedPosts = [];
  static List _likedPosts;
  static String _profileImage;

  String _authorProfileImg;
  String _authorNickname;
  String _authorName;
  String _authorMsg;
  List _authorPosts;

  String get uid => _uid;

  String get username => _username;

  String get email => _email;

  String get nickname => _nickname;

  String get profileMessage => _profileMessage;

  List get myPosts => _myPosts;

  List get bookmarkedPosts => _bookmarkedPosts;

  List get likedPosts => _likedPosts;

  String get profileImage => _profileImage;

  String get authorProfileImg => _authorProfileImg;

  String get authorNickname => _authorNickname;

  String get authorName => _authorName;

  String get authorMsg => _authorMsg;

  List get authorPosts => _authorPosts;

  CollectionReference users =
      FirebaseFirestore.instance.collection(COLLECTION_USERS);

  Future<String> authorUserData(uid) async {
    String authorNickname;
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (documentSnapshot.exists) {
        _authorProfileImg = data[KEY_PROFILEIMG];
        _authorNickname = data[KEY_NICKNAME];
        _authorName = data[KEY_USERNAME];
        _authorMsg = data[KEY_PROFILMSG];
        _authorPosts = data[KEY_MYPOSTS];
        authorNickname = data[KEY_NICKNAME];
      }
    });

    return authorNickname;
  }

  void clearProfileImg() {
    _profileImage = null;
  }

  Future getUserData() async {
    User user = FirebaseAuth.instance.currentUser;

    _uid = user.uid;

    await users.doc(_uid).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (documentSnapshot.exists) {
        _email = data[KEY_EMAIL];
        _username = data[KEY_USERNAME];
        _nickname = data[KEY_NICKNAME];
        _myPosts = data[KEY_MYPOSTS];
        _bookmarkedPosts = data[KEY_BOOKMARKEDPOSTS];
        _likedPosts = data[KEY_LIKEDPOSTS];
        _profileImage = data[KEY_PROFILEIMG];
        _profileMessage = data[KEY_PROFILMSG];
        print('get user data!');

        notifyListeners();
      } else {
        print('Document does not exist on the database');
        _setUserData(user);
      }
    });
  }

  void addMyPost(did) {
    _myPosts.add(did);
    DocumentReference ref = users.doc(_uid);
    ref.update({KEY_MYPOSTS: _myPosts}).then(
        (value) => print('MyPostList updated'));
  }

  void _setUserData(User user) {
    DocumentReference ref = users.doc(_uid);

    ref
        .set({
          KEY_EMAIL: user.email,
          KEY_USERNAME: user.displayName,
          KEY_NICKNAME: null,
          KEY_PROFILMSG: "",
          KEY_MYPOSTS: [],
          KEY_BOOKMARKEDPOSTS: [],
          KEY_LIKEDPOSTS: [],
          KEY_PROFILEIMG: null
        })
        .then((value) => print("User Registed"))
        .catchError((error) => print("Failed to regist user: $error"));
    print('set user data');
    getUserData();
  }

  Future<void> updateProfile(String nickname, String profileMessage) async {
    String imgUrl = await GalleryState().uploadAndDownloadUserImg();

    users.doc(_uid).update({
      KEY_NICKNAME: nickname,
      KEY_PROFILMSG: profileMessage,
      KEY_PROFILEIMG: imgUrl
    }).then((value) {
      print("Profile updated");
      _nickname = nickname;
      _profileMessage = profileMessage;
      _profileImage = imgUrl;
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
    if (_bookmarkedPosts != null) {
      result = _bookmarkedPosts.contains(postDid);
    }
    return result;
  }

  void like(String postDid) {
    print(postDid);
    _likedPosts.insert(0, postDid);
    print(_likedPosts);

    users.doc(_uid).update({'liked_posts': _likedPosts}).then((value) {
      print("liked");
    }).catchError((error) => print("Failed to like: $error"));
    notifyListeners();
  }

  void unlike(String postDid) {
    print(postDid);
    _likedPosts.remove(postDid);
    print(_likedPosts);
    users.doc(_uid).update({'liked_posts': _likedPosts}).then((value) {
      print("unlike");
    }).catchError((error) => print("Failed to unlike: $error"));
    notifyListeners();
  }

  bool isLiked(String postDid) {
    bool result = false;
    if (_likedPosts != null) {
      result = _likedPosts.contains(postDid);
    }
    return result;
  }
}
