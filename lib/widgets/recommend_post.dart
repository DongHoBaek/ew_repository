import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/detail_post_screen.dart';

class RecommendPost extends StatelessWidget {
  Map<String, dynamic> postMap;
  String authorNickname;

  RecommendPost(
      {Key key, @required this.postMap, @required this.authorNickname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Container(
        width: 240,
        decoration: postMap[KEY_POSTIMG] == null
            ? BoxDecoration(color: Colors.grey)
            : BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(postMap[KEY_POSTIMG]),
                ),
              ),
        child: InkWell(
          child: _postInfo(),
          onTap: () async {
            await Provider.of<PostProvider>(context, listen: false)
                .getPostData(postMap[KEY_POSTDID]);
            await Provider.of<UserProvider>(context, listen: false)
                .getOtherUserData(postMap[KEY_AUTHORUID]);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DetailPostScreen(
                      postMap:
                          Provider.of<PostProvider>(context).currentPostMap,
                    )));
          },
        ),
      ),
    );
  }

  Row _postInfo() {
    return Row(
      children: [
        Container(
            width: 240,
            color: Colors.black38,
            child: Padding(
              padding: const EdgeInsets.all(common_s_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    postMap[KEY_TITLE],
                    style: TextStyle(fontSize: font_size, color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    authorNickname != null
                        ? authorNickname
                        : postMap[KEY_AUTHORUNM],
                    style:
                        TextStyle(fontSize: font_xs_size, color: Colors.white),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
