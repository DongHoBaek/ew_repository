import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider with ChangeNotifier{
  File _image;

  File get image => _image;

  void pickImage() async {
    PickedFile pickedFileImage = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(pickedFileImage.path);

    _image = image;

    notifyListeners();
  }

  void clearImage(){
    _image = null;

    print('image: $_image');

    notifyListeners();
  }
}
