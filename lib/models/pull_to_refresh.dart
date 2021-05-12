import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ttt_project_003/models/post_provider.dart';

class PullToRefresh{
  var context;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  PullToRefresh(this.context);

  RefreshController get refreshController => _refreshController;

  void onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    Provider.of<PostProvider>(context, listen: false).getPostList(false);
    _refreshController.refreshCompleted();
  }

  void onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

}