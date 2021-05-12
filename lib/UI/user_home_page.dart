import 'package:flutter/material.dart';

class UserHomePage extends Page {
  static final String pageName = 'UserHomePage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => UserHome());
  }
}

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    Size size  = MediaQuery.of(context).size;

    Widget _buildPostButton(Function onTap) {
      return Container(
        margin: EdgeInsets.all(10),
        height: size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: ListTile(onTap: onTap),
      );
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'MyPage',
            style: TextStyle(color: Colors.black),
          )),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildPostButton(() {});
        }
        ),
    );
  }
}