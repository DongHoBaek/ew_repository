import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/widgets/my_progress_indicator.dart';
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
                return FutureBuilder(
                    future: UserProvider()
                        .authorUserData(postProvider.homePostList[index][1]),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('데이터 불러오기 실패'));
                      } else if (snapshot.hasData == false) {
                        return MyProgressIndicator();
                      } else {
                        return Post(
                          postList: postProvider.homePostList[index],
                          authorNickname: snapshot.data.toString(),
                        );
                      }
                    });
              });
    });
  }
}
