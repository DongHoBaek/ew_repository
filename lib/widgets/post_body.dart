import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/widgets/my_progress_indicator.dart';
import 'package:ttt_project_003/widgets/post.dart';

class PostBody extends StatelessWidget {
  List postList;

  PostBody({Key key, @required this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return postList.length == 0
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                        return Post(
                          postMap: postList[index],
                          authorNickname: snapshot.data.toString(),
                        );
                      }
                    });
              });
  }
}
