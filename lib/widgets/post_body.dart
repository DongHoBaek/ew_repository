import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/widgets/post.dart';

class PostBody extends StatelessWidget {
  PostBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(builder:
        (BuildContext context, PostProvider postProvider, Widget child) {
      return postProvider.homePostList.length == 0
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: postProvider.homePostList.length,
              itemBuilder: (context, index) {
                return Post(postList: postProvider.homePostList[index]);
              });
    });
  }
}
