import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _uid;
  String _name;
  String _email;
  List<String> _bookmarkList;
  List<String> _likeList;

  String get uid => _uid;

  String get name => _name;

  String get email => _email;

  List<String> get bookmarkList => _bookmarkList;

  List<String> get likeList => _likeList;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void login() {
    User user = FirebaseAuth.instance.currentUser;

    _uid = user.uid;
    _name = user.displayName;
    _name = user.email;

    if(!isReg()){
      register();
    }
  }

  bool isReg(){
    bool ret;

    users.where("uid", isEqualTo: _uid).get()
        .then((snapshot) {
          ret = snapshot.docs.isNotEmpty;
    });

    return ret;
  }

  void register(){
    DocumentReference ref = users.doc();

    ref.set({'uid':_uid});
    ref.collection("bookmarkList");
    ref.collection("likeList");
  }

  void degister(){
    users.where("uid", isEqualTo: _uid).get()
        .then((snapshot){
          DocumentReference doc = snapshot.docs.first.reference;
          doc.delete()
              .then((value) => print("User Degist"))
              .catchError((error) => print("Failed to Degist user: $error"));
    });
  }
}
