import 'package:flutter/foundation.dart';

class PageNavProvider extends ChangeNotifier {
  String _currentPage = 'HomePage';

  String get currentPage => _currentPage;

  void goToOtherPage(String pageName){
    _currentPage = pageName;
    notifyListeners();
  }
}