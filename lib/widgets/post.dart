import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/detail_post_screen.dart';
import 'package:ttt_project_003/util/time_formatter.dart';

class Post extends StatelessWidget {
  Map<String, dynamic> postMap;
  String authorNickname;

  Post({Key key, @required this.postMap, @required this.authorNickname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: common_gap, right: common_gap, bottom: common_gap),
      child: InkWell(
        onTap: () async {
          await Provider.of<PostProvider>(context, listen: false)
              .getPostData(postMap[KEY_POSTDID]);
          await Provider.of<UserProvider>(context, listen: false)
              .getOtherUserData(postMap[KEY_AUTHORUID]);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DetailPostScreen(
                    postMap: Provider.of<PostProvider>(context).currentPostMap,
                  )));
        },
        child: Container(
          height: size.height * 0.18,
          padding: EdgeInsets.all(common_gap),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [_imageBox(), _postInfo()],
          ),
        ),
      ),
    );
  }

  Container _imageBox() {
    return Container(
      width: size.height * 0.14,
      child: postMap[KEY_POSTIMG] == null
          ? Container(
              color: Colors.black26,
              child: Center(child: Text('No Image')),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: postMap[KEY_POSTIMG],
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Expanded _postInfo() {
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: common_s_gap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postMap[KEY_TITLE],
                style: TextStyle(fontSize: font_size),
              ),
              Spacer(),
              Text(
                authorNickname != null
                    ? authorNickname
                    : postMap[KEY_AUTHORUNM],
                style: TextStyle(fontSize: font_xs_size),
              ),
              Text(
                timeFormatter(postMap[KEY_POSTTIME]),
                style: TextStyle(fontSize: font_xs_size),
              ),
              Row(
                children: [
                  Icon(Icons.favorite_outline, color: Colors.red),
                  Text(
                    postMap[KEY_NUMOFLIKES].toString(),
                    style: TextStyle(fontSize: font_xs_size),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
