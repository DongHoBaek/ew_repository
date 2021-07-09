import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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
    print('write post screen에서 GalleryState.clearImage 실행 됨');
    notifyListeners();
  }

  Future<String> uploadAndDownloadPostImg(DateTime dateTime) async {
    String downloadURL;

    if (_image != null) {
      File imageFile = File(_image.path);
      Reference reference = _firebaseStorage
          .ref()
          .child('PostImg/')
          .child('${UserProvider().uid}/$dateTime');
      await reference.putFile(imageFile);

      downloadURL = (await reference.getDownloadURL()).toString();
    }
    return downloadURL;
  }

  Future<String> uploadAndDownloadUserImg() async {
    String downloadURL;

    if (_image != null) {
      File imageFile = File(_image.path);
      Reference reference =
          _firebaseStorage.ref().child('UserImg/${UserProvider().uid}');
      await reference.putFile(imageFile);

      downloadURL = (await reference.getDownloadURL()).toString();
    }else if(UserProvider().profileImage != null){
      downloadURL = UserProvider().profileImage;
    }

    return downloadURL;
  }
}
