import 'package:flutter/foundation.dart';

class PageNavProvider extends ChangeNotifier {
  String _currentPage = 'HomePage';

  List<String> _pageList = ['HomePage'];

  String get currentPage => _currentPage;
  List<String> get pageList => _pageList;

  void goToOtherPage(String pageName) {
    _currentPage = pageName;
    _pageList.add(_currentPage);
    print(_pageList);
    notifyListeners();
  }

  void goBack(){
    _currentPage = _pageList[_pageList.length - 2];
    _pageList.removeAt(_pageList.length - 1);
    print(_pageList);
    notifyListeners();
  }
}
