import 'package:flutter/foundation.dart';

class PageNavProvider extends ChangeNotifier {
  String _lastPage = 'HomePage';
  String _currentPage = 'HomePage';

  String get lastPage => _lastPage;
  String get currentPage => _currentPage;

  void goToOtherPage(String pageName) {
    _lastPage = _currentPage;
    _currentPage = pageName;
    notifyListeners();
  }

  void goBack(){
    _currentPage = _lastPage;
    print(_currentPage);
    notifyListeners();
  }
}
