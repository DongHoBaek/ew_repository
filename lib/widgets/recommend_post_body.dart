import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/repository/post_repo.dart';
import 'package:ttt_project_003/widgets/recommend_post.dart';


class RecommendPostBody extends StatelessWidget {
  const RecommendPostBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostRepo _postRepo = PostRepo();

    return Container(
      height: size.height * 0.16,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _postRepo.postList.length,
          itemBuilder: (context, index) {
            return RecommendPost(postList: _postRepo.recommendPostList[index]);
          }),
    );
  }
}