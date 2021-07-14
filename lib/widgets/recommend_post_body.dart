import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/widgets/recommend_post.dart';

import 'my_progress_indicator.dart';

class RecommendPostBody extends StatelessWidget {
  List<Map<String, dynamic>> postList = [];

  RecommendPostBody({Key key, @required this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return postList.length == 0
        ? Container()
        : Container(
            height: size.height * 0.16,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: UserProvider()
                          .getOtherUserData(postList[index][KEY_AUTHORUID]),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('데이터 불러오기 실패'));
                        } else if (snapshot.hasData == false) {
                          return MyProgressIndicator();
                        } else {
                          return RecommendPost(
                            postMap: postList[index],
                            authorNickname: snapshot.data.toString(),
                          );
                        }
                      });
                }),
          );
  }
}
