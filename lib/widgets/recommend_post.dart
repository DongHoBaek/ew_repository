import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ttt_project_003/constant/common_size.dart';


class RecommendPost extends StatelessWidget {
  List postList;

  RecommendPost({Key key, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(postList[5]),
          ),
        ),
        child: InkWell(
          child: _postInfo(),
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (_) => DetailPostScreen(postList: this.postList)));
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
                    postList[0],
                    style: TextStyle(fontSize: font_size, color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    postList[2],
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
