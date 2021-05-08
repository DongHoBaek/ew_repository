import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/UI/user_home_page.dart';
import 'package:ttt_project_003/UI/write_post_page.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'detail_post_page.dart';

class HomePage extends Page {
  static final String pageName = 'HomePage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => Home());
  }
}

class Home extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

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
                Provider.of<PageNavProvider>(context, listen: false).goToOtherPage(
                    UserHomePage.pageName);
              }, '마이페이지'),
              _buildDrawerButton(Icons.logout, () {}, '로그아웃'),
            ],
          ),
        ),
      );
    }

    Widget _buildPostButton(Function onTap) {
      return Container(
        margin: EdgeInsets.all(10),
        height: size.height * 0.3,
        decoration: BoxDecoration(color: Colors.grey[200],),
        child: ListTile(
            onTap: onTap
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('HomePage', style: TextStyle(color: Colors.black),)
      ),
      drawer: _buildDrawer(),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildPostButton(() {
                  Provider.of<PageNavProvider>(context, listen: false)
                      .goToOtherPage(DetailPostPage.pageName);
                });
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: () {
          Provider.of<PageNavProvider>(context, listen: false).goToOtherPage(
              WritePostPage.pageName);
        },
      ),
    );
  }
}
