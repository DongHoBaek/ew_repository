import 'package:flutter/material.dart';
import 'package:ttt_project_003/screens/write_post_screen.dart';
import 'package:ttt_project_003/widgets/custom_drawer.dart';
import 'package:ttt_project_003/widgets/header.dart';
import 'package:ttt_project_003/widgets/post_body.dart';
import 'package:ttt_project_003/widgets/recommend_post_body.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() {
    return _FeedScreenState();
  }
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Feed Screen'),
        actions: [Switch(value: true, onChanged: (value) {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              text: 'Today\'s topic',
              actions: [
                InkWell(
                  child: Text('더보기'),
                )
              ],
            ),
            RecommendPostBody(),
            Header(text: 'Post'),
            PostBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => WritePostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
