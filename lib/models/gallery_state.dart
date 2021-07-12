import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class GalleryState extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  static PickedFile _image;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  PickedFile get image => _image;

  Future getImage() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    _image = image;
    notifyListeners();
  }

  void clearImage() {
    _image = null;
    // UserProvider().clearProfileImg();
    print('GalleryState.clearImage 실행 됨');
    notifyListeners();
  }

  Future<String> updatePostImg(String did) async {
    String downloadURL;
    String imgName = did.split('_')[0];

    if (_image != null) {
      File imageFile = File(_image.path);
      Reference reference = _firebaseStorage
          .ref()
          .child('PostImg/')
          .child('${UserProvider().userDataMap[KEY_USERUID]}/$imgName');
      await reference.putFile(imageFile);

      downloadURL = (await reference.getDownloadURL()).toString();
    } else if (PostProvider().currentPostMap[KEY_POSTIMG] != null) {
      downloadURL = PostProvider().currentPostMap[KEY_POSTIMG];
    }
    return downloadURL;
  }

  Future<String> uploadAndDownloadPostImg(DateTime dateTime) async {
    String downloadURL;

    if (_image != null) {
      File imageFile = File(_image.path);
      Reference reference = _firebaseStorage
          .ref()
          .child('PostImg/')
          .child('${UserProvider().userDataMap[KEY_USERUID]}/$dateTime');
      await reference.putFile(imageFile);

      downloadURL = (await reference.getDownloadURL()).toString();
    } else if (PostProvider().currentPostMap[KEY_POSTIMG] != null) {
      downloadURL = PostProvider().currentPostMap[KEY_POSTIMG];
    }
    return downloadURL;
  }

  Future<String> uploadAndDownloadUserImg() async {
    String downloadURL;

    if (_image != null) {
      File imageFile = File(_image.path);
      Reference reference =
          _firebaseStorage.ref().child('UserImg/${UserProvider().userDataMap[KEY_USERUID]}');
      await reference.putFile(imageFile);

      downloadURL = (await reference.getDownloadURL()).toString();
    } else if (UserProvider().userDataMap[KEY_PROFILEIMG] != null) {
      downloadURL = UserProvider().userDataMap[KEY_PROFILEIMG];
    } else {
      Reference reference =
          _firebaseStorage.ref().child('UserImg/${UserProvider().userDataMap[KEY_USERUID]}');
      await reference.delete();
    }

    return downloadURL;
  }

  Future deletePostImg(String did) async {
    String imgName = did.split('_')[0];

    Reference reference = _firebaseStorage
        .ref()
        .child('PostImg/')
        .child('${UserProvider().userDataMap[KEY_USERUID]}/$imgName');

    await reference.delete();
  }
}
