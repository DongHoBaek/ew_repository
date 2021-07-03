import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ttt_project_003/UI/user_home_page.dart';
import 'package:ttt_project_003/UI/write_post_page.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/pull_to_refresh.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/widget/setting_user_profile.dart';

import 'detail_post_page.dart';

class HomePage extends Page {
  static final String pageName = 'HomePage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isViewComment = true;

  @override
  Widget build(BuildContext context) {
    PullToRefresh pullToRefresh = PullToRefresh(context);
    double size = MediaQuery.of(context).size.height;
    print('HomePage build!');

    Widget _buildToggleButton() {
      return Switch(
          activeColor: Colors.blueAccent,
          value: _isViewComment,
          onChanged: (bool value) {
            setState(() {
              _isViewComment = value;
            });
            Provider.of<PostProvider>(context, listen: false).changeDisplay();
          });
    }

    Widget _buildDrawerButton(Function onTap, String title) {
      return ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget _buildDrawer() {
      print('name: ' + Provider.of<UserProvider>(context, listen: false).username);
      return Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text(
                Provider.of<UserProvider>(context, listen: false).username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            _buildDrawerButton(() async {
              Navigator.pop(context);
              Provider.of<PostProvider>(context, listen: false).getMyPostList(
                  Provider.of<UserProvider>(context, listen: false).uid);
              Provider.of<PageNavProvider>(context, listen: false)
                  .goToOtherPage(context, UserHomePage.pageName);
            }, '마이페이지'),
            _buildDrawerButton(() {
              Provider.of<UserProvider>(context, listen: false).logout();
            }, '로그아웃'),
          ],
        ),
      );
    }

    Widget _buildSuggestPostButton(double width, String title, Function onTap) {
      return Container(
          padding: EdgeInsets.only(left: 4),
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 4),
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[400],
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    }

    Widget _buildPostButton(
        double height, String unm, String title, dateTime, String postId,Function onTap) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[400],
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text('$unm'),
                        Text('$dateTime', style: TextStyle(
                          color: Colors.grey
                        ),),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Provider.of<UserProvider>(context, listen: false).isLiked(postId) ?
                              Icons.favorite : Icons.favorite_outline,
                              color: Colors.red,
                            ),
                            Text(Provider.of<PostProvider>(context).likes.toString())
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    }

    Widget _buildSuggestPostList() {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildSuggestPostButton(232, '임시', () {});
          });
    }

    Widget _buildSuggestPostListArea() {
      return Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 30,
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                'Today\'s topic',
                textScaleFactor: 1.3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '더보기',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        Container(
          height: 120,
          child: _buildSuggestPostList(),
        ),
      ]);
    }

    Widget _buildPostList(postProvider) {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: postProvider.homePostList.length,
          itemBuilder: (context, index) {
            return _buildPostButton(
                120,
                postProvider.homePostList[index][2],
                postProvider.homePostList[index][3],
                postProvider.homePostList[index][1],
                postProvider.homePostList[index][0], () {
              postProvider
                  .getPostData(postProvider.homePostList[index][0])
                  .whenComplete(() =>
                      Provider.of<PageNavProvider>(context, listen: false)
                          .goToOtherPage(context, DetailPostPage.pageName));
              postProvider.getChildPostList();
            });
          });
    }

    Widget _buildPostListArea(postProvider) {
      return Column(children: [
        Container(
          height: size * 0.1,
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                'Post',
                textScaleFactor: 1.3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        _buildPostList(postProvider),
      ]);
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text(
                  'HomePage',
                  style: TextStyle(color: Colors.black),
                ),
                actions: [_buildToggleButton()],
              ),
              drawer: _buildDrawer(),
              body: Consumer<PostProvider>(
                builder: (context, postProvider, child) {
                  print('HomePage postProvider consumer!');
                  if (postProvider.homePostList.isEmpty) {
                    Provider.of<PostProvider>(context, listen: false).getHomePostList();
                    return Container();
                  } else {
                    return SmartRefresher(
                        enablePullDown: true,
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = Text("pull up load");
                            } else if (mode == LoadStatus.loading) {
                              body = CircularProgressIndicator();
                            } else if (mode == LoadStatus.failed) {
                              body = Text("Load Failed!Click retry!");
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text("release to load more");
                            } else {
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        controller: pullToRefresh.refreshController,
                        onRefresh: pullToRefresh.onRefresh,
                        onLoading: pullToRefresh.onLoading,
                        child: Container(
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Column(children: [
                              _buildSuggestPostListArea(),
                              _buildPostListArea(postProvider)
                            ]),
                          ),
                        ));
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  Provider.of<PostProvider>(context, listen: false).removeDocId();
                  Provider.of<PageNavProvider>(context, listen: false)
                      .goToOtherPage(context, WritePostPage.pageName);
                },
              ),
            ),
            userProvider.nickname == null ? SettingUserProfile() : Container()
          ],
        );
      }
    );
  }
}
