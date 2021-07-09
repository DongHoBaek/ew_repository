import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/screens/detail_post_screen.dart';

class Post extends StatelessWidget {
  List postList;

  Post({Key key, @required this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: common_gap, right: common_gap, bottom: common_gap),
      child: InkWell(
        onTap: () async{
          await Provider.of<PostProvider>(context, listen: false).getPostData(postList[0]);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DetailPostScreen(postList: Provider.of<PostProvider>(context).currentPostList,)));
        },
        child: Container(
          height: size.height * 0.16,
          child: Row(
            children: [
              Container(
                width: size.height * 0.16,
                child: CachedNetworkImage(
                  imageUrl: postList[1],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postList[5],
                          style: TextStyle(fontSize: font_size),
                        ),
                        Spacer(),
                        Text(
                          postList[4],
                          style: TextStyle(fontSize: font_xs_size),
                        ),
                        Text(
                          postList[2],
                          style: TextStyle(fontSize: font_xs_size),
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite_outline, color: Colors.red),
                            Text(
                              postList[3].toString(),
                              style: TextStyle(fontSize: font_xs_size),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
