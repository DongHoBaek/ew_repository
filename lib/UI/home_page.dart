import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/UI/write_post_page.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';

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
    Size size = MediaQuery.of(context).size;

    Widget _buildPostButton(){
      return Container(
        margin: EdgeInsets.all(10),
        height: size.height*0.2,
        decoration: BoxDecoration(color: Colors.blueGrey,),
      );
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
                  backgroundColor: Colors.redAccent,
                ),
              ),
              Divider(
                color: Colors.black54,
                height: 1,
              ),
              _buildDrawerButton(Icons.home_outlined, () {}, '마이페이지'),
              _buildDrawerButton(Icons.logout, () {}, '로그아웃'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      drawer: _buildDrawer(),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child){
          postProvider.getPostList(false);
          return ListView.builder(
              itemCount: postProvider.postList.length,
              itemBuilder: (context, index) {
                return _buildPostButton();
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: (){
          Provider.of<PageNavProvider>(context, listen: false).goToOtherPage(WritePostPage.pageName);
        },
      ),
    );
  }
}
