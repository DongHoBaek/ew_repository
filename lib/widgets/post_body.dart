import 'package:flutter/material.dart';
import 'package:ttt_project_003/repository/post_repo.dart';
import 'package:ttt_project_003/widgets/post.dart';


class PostBody extends StatelessWidget {
  PostBody({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostRepo _postRepo = PostRepo();
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _postRepo.postList.length,
        itemBuilder: (context, index) {
          return Post(postList: _postRepo.postList[index]);
        });
  }
}
