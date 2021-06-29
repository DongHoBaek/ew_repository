import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';

class PageNavProvider extends ChangeNotifier {
  String _currentPage = 'HomePage';

  List _pageList = [
    [null, 'HomePage']
  ];

  String get currentPage => _currentPage;

  List<String> get pageList => _pageList;

  void goToOtherPage(context, String pageName) {
    _currentPage = pageName;
    _pageList.add([
      Provider.of<PostProvider>(context, listen: false).currentDocId,
      _currentPage
    ]);
    print(_pageList);
    notifyListeners();
  }

  void goBack(context) {
    _currentPage = _pageList[_pageList.length - 2][1];
    if (_pageList.length > 2) {
      Provider.of<PostProvider>(context, listen: false)
          .getPostData(_pageList[_pageList.length - 2][0]);
      Provider.of<PostProvider>(context, listen: false).getChildPostList();
    }
    _pageList.removeAt(_pageList.length - 1);
    print(_pageList);
    notifyListeners();
  }
}
