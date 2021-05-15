import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';

import 'detail_post_page.dart';

class UserHomePage extends Page {
  static final String pageName = 'UserHomePage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => UserHome());
  }
}

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User user = FirebaseAuth.instance.currentUser;

    Widget _buildAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
      );
    }

    Widget _buildUserInfo() {
      return Container(
        height: size.height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              user.displayName,
              textScaleFactor: 1.5,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }

    Widget _buildPostButton(
        double height, String unm, String title, Function onTap) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
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
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    }

    Widget _buildPostList(postProvider) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: postProvider.myPostList.length,
          itemBuilder: (context, index) {
            return _buildPostButton(size.height * 0.14, user.displayName,
                postProvider.myPostList[index][1], () {
              postProvider
                  .getPostData(postProvider.postList[index][0])
                  .whenComplete(() =>
                      Provider.of<PageNavProvider>(context, listen: false)
                          .goToOtherPage(DetailPostPage.pageName));
            });
          });
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          print('userPage postProvider consumer!');
          if (postProvider.postList.isEmpty) {
            Provider.of<PostProvider>(context, listen: false)
                .getPostList(false);
            return Container();
          } else {
            return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(children: [
                      _buildUserInfo(),
                      _buildPostList(postProvider)
                    ])));
          }
        },
      ),
    );
  }
}