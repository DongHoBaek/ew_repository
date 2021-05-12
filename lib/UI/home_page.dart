import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ttt_project_003/UI/user_home_page.dart';
import 'package:ttt_project_003/UI/write_post_page.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/pull_to_refresh.dart';

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
  User user = FirebaseAuth.instance.currentUser;

  bool _isViewComment = true;

  @override
  Widget build(BuildContext context) {
    PullToRefresh pullToRefresh = PullToRefresh(context);
    Size size = MediaQuery.of(context).size;
    print('HomePage build!');

    Widget _buildToggleButton() {
      return Switch(
          activeColor: Colors.blueAccent,
          value: _isViewComment,
          onChanged: (bool value) {
            setState(() {
              _isViewComment = value;
            });
          });
    }

    Widget _buildDrawerButton(IconData icon, Function onTap, String title) {
      return ListTile(
        leading: Icon(icon),
        onTap: onTap,
        title: Text(title),
      );
    }

    Widget _buildDrawer() {
      return Drawer(
        child: Container(
          color: Colors.grey[100],
          child: ListView(
            children: [
              ListTile(
                title: Text(user.displayName),
                subtitle: Text(user.email),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
              ),
              Divider(
                color: Colors.black54,
                height: 1,
              ),
              _buildDrawerButton(Icons.home_outlined, () {
                Navigator.pop(context);
                Provider.of<PageNavProvider>(context, listen: false)
                    .goToOtherPage(UserHomePage.pageName);
              }, '마이페이지'),
              _buildDrawerButton(Icons.logout, () {}, '로그아웃'),
            ],
          ),
        ),
      );
    }

    Widget _buildSuggestPostButton(double width, String title, Function onTap) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
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
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    }

    Widget _buildPostButton(
        double height, String unm, String title, Function onTap) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          height: height,
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
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text('$unm'),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            Text('120')
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
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
            return _buildSuggestPostButton(size.width * 0.65, '임시', () {});
          });
    }

    Widget _buildSuggestPostArea() {
      return Column(children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: size.height * 0.05,
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.05,
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
          height: size.height * 0.2,
          child: _buildSuggestPostList(),
        ),
      ]);
    }

    Widget _buildPostList(postProvider) {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: postProvider.postList.length,
          itemBuilder: (context, index) {
            return _buildPostButton(
                size.height * 0.2,
                postProvider.postList[index][1],
                postProvider.postList[index][2], () {
              postProvider
                  .getPostData(postProvider.postList[index][0])
                  .whenComplete(() =>
                      Provider.of<PageNavProvider>(context, listen: false)
                          .goToOtherPage(DetailPostPage.pageName));
            });
          });
    }

    Widget _buildPostListArea(postProvider) {
      return Column(children: [
        Container(
          height: size.height * 0.05,
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.05,
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

    return Scaffold(
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
          if (postProvider.postList.isEmpty) {
            Provider.of<PostProvider>(context, listen: false)
                .getPostList(false);
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
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: [
                    _buildSuggestPostArea(),
                    _buildPostListArea(postProvider)
                  ]),
                ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Provider.of<PageNavProvider>(context, listen: false)
              .goToOtherPage(WritePostPage.pageName);
        },
      ),
    );
  }
}
