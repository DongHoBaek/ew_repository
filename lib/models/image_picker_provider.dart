import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider with ChangeNotifier {
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  User _user = FirebaseAuth.instance.currentUser;
  File _image;
  String _profileImageURL;

  File get image => _image;
  String get profileImageURL => _profileImageURL;

  void uploadImageToFirebaseStorage() async {
    Reference ref = _firebaseStorage.ref().child("profile/${_user.uid}");

    ref.putFile(_image);

    String downloadURL = await ref.getDownloadURL();

    _profileImageURL = downloadURL;

    print(_profileImageURL);
  }

  void pickImage() async {
    PickedFile pickedFileImage =
        await imagePicker.getImage(source: ImageSource.gallery);
    File image = File(pickedFileImage.path);

    _image = image;

    notifyListeners();
  }

  void clearImage() {
    _image = null;

    print('image: $_image');

    notifyListeners();
  }
}
