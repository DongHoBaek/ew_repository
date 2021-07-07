import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class GalleryState extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  static PickedFile _image;

  PickedFile get image => _image;

  Future getImage() async{
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    _image = image;
    notifyListeners();
  }

  void clearImage(){
    _image = null;
    print('write post screen에서 GalleryState.clearImage 실행 됨');
    notifyListeners();
  }
}
