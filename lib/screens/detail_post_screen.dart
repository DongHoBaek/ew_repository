import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/write_post_screen.dart';
import 'package:ttt_project_003/widgets/header.dart';
import 'package:ttt_project_003/widgets/recommend_post_body.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';

class DetailPostScreen extends StatelessWidget {
  final Map<String, dynamic> postMap;

  DetailPostScreen({Key key, @required this.postMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_popupBtn()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: common_gap, top: common_gap, right: common_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _goRootPost(),
                  SizedBox(height: common_gap),
                  _goParentPost(),
                  _userInfo(context),
                  _imageBox(),
                  _titleBox(),
                  _contentBox(),
                  _commentHeader(),
                ],
              ),
            ),
            _commentBody()
          ],
        ),
      ),
    );
  }

  PopupMenuButton _popupBtn() {
    return PopupMenuButton(
        icon: Icon(Icons.more_horiz),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                child: Container(
              height: 48,
              width: 80,
              child: InkWell(
                child: Center(
                    child: Text(
                  '편집',
                )),
                onTap: () {
                  print('편집 버튼 클릭됨');
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => WritePostScreen(
                            inputTitle: postMap[KEY_TITLE],
                            inputContent: postMap[KEY_CONTENT],
                            imageUrl: postMap[KEY_POSTIMG],
                          )));
                },
              ),
            )),
            PopupMenuItem(
                child: Container(
              height: 48,
              width: 80,
              child: InkWell(
                child: Center(
                    child: Text(
                  '삭제',
                )),
                onTap: () {},
              ),
            )),
            PopupMenuItem(
                child: Container(
              height: 48,
              width: 80,
              child: InkWell(
                child: Center(
                    child: Text(
                  '익명화',
                )),
                onTap: () {},
              ),
            )),
            PopupMenuItem(
                child: Container(
              height: 48,
              width: 80,
              child: InkWell(
                child: Center(
                    child: Text(
                  '신고',
                )),
                onTap: () {},
              ),
            )),
          ];
        });
  }

  Padding _commentBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: common_gap),
      child: RecommendPostBody(),
    );
  }

  Header _commentHeader() {
    return Header(
      text: '댓글',
      padding: 0.0,
      actions: [
        InkWell(
          child: Text('더보기'),
          onTap: () {},
        )
      ],
    );
  }

  Header _titleBox() {
    return Header(
      text: postMap[KEY_TITLE],
      padding: 0.0,
      actions: [
        Icon(Icons.favorite_outline),
        SizedBox(
          width: common_xxs_gap,
        ),
        Icon(Icons.bookmark_outline)
      ],
    );
  }

  Container _contentBox() {
    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.17),
      child: Text(postMap[KEY_CONTENT], maxLines: null),
    );
  }

  Container _imageBox() {
    return Container(
      width: size.width,
      height: 200,
      color: Colors.grey,
      child: CachedNetworkImage(
        imageUrl: postMap[KEY_POSTIMG],
        fit: BoxFit.cover,
      ),
    );
  }

  Padding _userInfo(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: common_gap),
      child: Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RoundedAvatar(
                  size: 40,
                  imageUrl:
                      Provider.of<UserProvider>(context).authorProfileImg),
              SizedBox(
                width: common_gap,
              ),
              Text(
                Provider.of<UserProvider>(context).authorNickname,
                style:
                    TextStyle(fontSize: font_size, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }

  InkWell _goParentPost() {
    return InkWell(
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_outlined,
            size: 10,
          ),
          Text('이전 가지 게시물로 가기')
        ],
      ),
      onTap: () {},
    );
  }

  InkWell _goRootPost() {
    return InkWell(
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_outlined,
            size: 10,
          ),
          Text('뿌리 게시물로 가기')
        ],
      ),
      onTap: () {},
    );
  }
}
