import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/profile_screen.dart';
import 'package:ttt_project_003/screens/write_post_screen.dart';
import 'package:ttt_project_003/widgets/header.dart';
import 'package:ttt_project_003/widgets/recommend_post_body.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';

class DetailPostScreen extends StatefulWidget {
  Map<String, dynamic> postMap;

  DetailPostScreen({Key key, @required this.postMap}) : super(key: key);

  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  bool _isMine;
  bool _isLike;
  bool _isBookmark;

  @override
  void initState() {
    _isMine =
        UserProvider().userDataMap[KEY_USERUID] == widget.postMap[KEY_AUTHORUID]
            ? true
            : false;

    _isLike = UserProvider().isLiked(PostProvider().currentDocIdStack.last);

    _isBookmark =
        UserProvider().isBookmarked(PostProvider().currentDocIdStack.last);

    super.initState();
  }

  @override
  void dispose() {
    PostProvider().removeLastDocId();
    super.dispose();
  }

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
          return _isMine
              ? [
                  PopupMenuItem(
                      child: Container(
                    height: 48,
                    width: 80,
                    child: InkWell(
                      child: Center(
                          child: Text(
                        '??????',
                      )),
                      onTap: () {
                        print('?????? ?????? ?????????');
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => WritePostScreen(
                                  inputTitle: widget.postMap[KEY_TITLE],
                                  inputContent: widget.postMap[KEY_CONTENT],
                                  imageUrl: widget.postMap[KEY_POSTIMG],
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
                        '??????',
                      )),
                      onTap: () {
                        print('?????? ?????? ?????????');
                        Navigator.pop(context);
                        Provider.of<PostProvider>(context, listen: false)
                            .deletePost();
                        Navigator.pop(context);
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
                        '?????????',
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
                        '??????',
                      )),
                      onTap: () {},
                    ),
                  )),
                ]
              : [
                  PopupMenuItem(
                      child: Container(
                    height: 48,
                    width: 80,
                    child: InkWell(
                      child: Center(
                          child: Text(
                        '??????',
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _addCommentBtn(),
            RecommendPostBody(
              postList: Provider.of<PostProvider>(context).childPosts,
            ),
          ],
        ),
      ),
    );
  }

  Padding _addCommentBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => WritePostScreen()));
        },
        child: Container(
          height: size.height * 0.16,
          width: size.height * 0.16,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Center(child: Icon(Icons.add)),
        ),
      ),
    );
  }

  Header _commentHeader() {
    return Header(
      text: '??????',
      padding: 0.0,
      actions: [
        InkWell(
          child: Text('?????????'),
          onTap: () {},
        )
      ],
    );
  }

  Header _titleBox() {
    return Header(
      text: widget.postMap[KEY_TITLE],
      padding: 0.0,
      actions: [
        InkWell(
            onTap: () {
              if (_isLike == false) {
                setState(() {
                  _isLike = true;
                });
                Provider.of<UserProvider>(context, listen: false).like(
                    Provider.of<PostProvider>(context, listen: false)
                        .currentDocIdStack
                        .last);
              } else {
                setState(() {
                  _isLike = false;
                });
                Provider.of<UserProvider>(context, listen: false).unlike(
                    Provider.of<PostProvider>(context, listen: false)
                        .currentDocIdStack
                        .last);
              }
            },
            child: Icon(
              _isLike ? Icons.favorite : Icons.favorite_outline,
              color: Colors.red[300],
            )),
        SizedBox(
          width: common_xs_gap,
        ),
        InkWell(
            onTap: () {
              if (_isBookmark == false) {
                setState(() {
                  _isBookmark = true;
                });
                Provider.of<UserProvider>(context, listen: false).bookmark(
                    Provider.of<PostProvider>(context, listen: false)
                        .currentDocIdStack
                        .last);
              } else {
                setState(() {
                  _isBookmark = false;
                });
                Provider.of<UserProvider>(context, listen: false).unbookmark(
                    Provider.of<PostProvider>(context, listen: false)
                        .currentDocIdStack
                        .last);
              }
            },
            child: Icon(
              _isBookmark ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.blue[300],
            ))
      ],
    );
  }

  Container _contentBox() {
    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.17),
      child: Text(widget.postMap[KEY_CONTENT], maxLines: null),
    );
  }

  Container _imageBox() {
    return Container(
      width: size.width,
      height: 200,
      color: Colors.grey,
      child: widget.postMap[KEY_POSTIMG] == null
          ? Container(
              child: Center(child: Text('No Image')),
            )
          : CachedNetworkImage(
              imageUrl: widget.postMap[KEY_POSTIMG],
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
              InkWell(
                onTap: () async {
                  await Provider.of<PostProvider>(context, listen: false)
                      .getOtherUserPosts();
                  await Provider.of<PostProvider>(context, listen: false)
                      .getBookmarkPosts();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => _isMine
                          ? ProfileScreen(
                              postList: Provider.of<PostProvider>(context)
                                  .otherUserPosts,
                              bookmarkPostList:
                                  Provider.of<PostProvider>(context)
                                      .bookmarkPosts,
                            )
                          : ProfileScreen(
                              postList: Provider.of<PostProvider>(context)
                                  .otherUserPosts,
                              userMap: Provider.of<UserProvider>(context)
                                  .otherUserDataMap,
                            )));
                },
                child: RoundedAvatar(
                    size: 40,
                    imageUrl: Provider.of<UserProvider>(context)
                        .otherUserDataMap[KEY_PROFILEIMG]),
              ),
              SizedBox(
                width: common_gap,
              ),
              Text(
                Provider.of<UserProvider>(context)
                    .otherUserDataMap[KEY_NICKNAME],
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
            color: Provider.of<PostProvider>(context)
                        .currentPostMap[KEY_PARENTPOSTDID] !=
                    null
                ? Colors.black
                : Colors.grey,
          ),
          Text(
            '?????? ?????? ???????????? ??????',
            style: TextStyle(
              color: Provider.of<PostProvider>(context)
                          .currentPostMap[KEY_PARENTPOSTDID] !=
                      null
                  ? Colors.black
                  : Colors.grey,
            ),
          )
        ],
      ),
      onTap: () async {
        if (Provider.of<PostProvider>(context, listen: false)
                .currentPostMap[KEY_PARENTPOSTDID] !=
            null) {
          await Provider.of<PostProvider>(context, listen: false).getPostData(
              Provider.of<PostProvider>(context, listen: false)
                  .currentPostMap[KEY_PARENTPOSTDID]);
          await Provider.of<UserProvider>(context, listen: false)
              .getOtherUserData(
                  Provider.of<PostProvider>(context, listen: false)
                      .currentPostMap[KEY_AUTHORUID]);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DetailPostScreen(
                    postMap: Provider.of<PostProvider>(context, listen: false)
                        .currentPostMap,
                  )));
        }
      },
    );
  }

  InkWell _goRootPost() {
    return InkWell(
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_outlined,
            size: 10,
            color: Provider.of<PostProvider>(context, listen: false)
                        .currentPostMap[KEY_ROOTPOSTDID] !=
                    Provider.of<PostProvider>(context, listen: false)
                        .currentPostMap[KEY_POSTDID]
                ? Colors.black
                : Colors.grey,
          ),
          Text(
            '?????? ???????????? ??????',
            style: TextStyle(
              color: Provider.of<PostProvider>(context, listen: false)
                          .currentPostMap[KEY_ROOTPOSTDID] !=
                      Provider.of<PostProvider>(context, listen: false)
                          .currentPostMap[KEY_POSTDID]
                  ? Colors.black
                  : Colors.grey,
            ),
          )
        ],
      ),
      onTap: () async {
        if (Provider.of<PostProvider>(context, listen: false)
                .currentPostMap[KEY_ROOTPOSTDID] !=
            Provider.of<PostProvider>(context, listen: false)
                .currentPostMap[KEY_POSTDID]) {
          await Provider.of<PostProvider>(context, listen: false).getPostData(
              Provider.of<PostProvider>(context, listen: false)
                  .currentPostMap[KEY_ROOTPOSTDID]);
          await Provider.of<UserProvider>(context, listen: false)
              .getOtherUserData(
                  Provider.of<PostProvider>(context, listen: false)
                      .currentPostMap[KEY_AUTHORUID]);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DetailPostScreen(
                    postMap: Provider.of<PostProvider>(context, listen: false)
                        .currentPostMap,
                  )));
        }
      },
    );
  }
}
