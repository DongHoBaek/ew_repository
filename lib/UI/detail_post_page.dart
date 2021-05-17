import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/UI/write_post_page.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class DetailPostPage extends Page {
  static final String pageName = 'DetailPostPage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (context) => DetailPost());
  }
}

class DetailPost extends StatefulWidget {
  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  bool isLiked = false;
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: Provider.of<PostProvider>(context).title);
    TextEditingController contentController =
        TextEditingController(text: Provider.of<PostProvider>(context).content);
    Size size = MediaQuery.of(context).size;

    Widget _buildSaveButton() {
      return IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            Provider.of<PostProvider>(context, listen: false)
                .updatePost(titleController.text, contentController.text);
            Provider.of<PostProvider>(context, listen: false)
                .getChildPostList();
            setState(() {
              isEdit = false;
            });
          });
    }

    PopupMenuEntry _buildPopupMenuItem(String title, Function onPressed) {
      return PopupMenuItem(
          child: TextButton(
        child: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        onPressed: onPressed,
      ));
    }

    Widget _buildPopupMenuButton() {
      return PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) {
            return Provider.of<UserProvider>(context, listen: false).uid ==
                    Provider.of<PostProvider>(context, listen: false).uid
                ? [
                    _buildPopupMenuItem('편집', () {
                      setState(() {
                        isEdit = true;
                      });
                      Navigator.pop(context);
                    }),
                    _buildPopupMenuItem('삭제', () {
                      Navigator.pop(context);
                      Provider.of<PostProvider>(context, listen: false)
                          .deletePost();
                      Provider.of<PostProvider>(context, listen: false)
                          .getHomePostList();
                      Provider.of<PageNavProvider>(context, listen: false).goBack(context);
                    }),
                    _buildPopupMenuItem('익명화', () {
                      Navigator.pop(context);
                      Provider.of<PostProvider>(context, listen: false)
                          .anonymizationPost();
                      Provider.of<PostProvider>(context, listen: false)
                          .getHomePostList();
                    }),
                    _buildPopupMenuItem('신고', () {}),
                  ]
                : [
                    _buildPopupMenuItem('신고', () {}),
                  ];
          });
    }

    Widget _buildEditTitle() {
      return TextFormField(
        controller: titleController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '본문을 입력하세요',
        ),
      );
    }

    Widget _buildAppBar() {
      return AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: isEdit ? _buildEditTitle() : Container(),
          actions: [isEdit ? _buildSaveButton() : _buildPopupMenuButton()]);
    }

    Widget _buildFamilyPostRow(text, onTap) {
      return InkWell(
        child: Container(
          height: size.height * 0.04,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.arrow_back_ios_outlined,
                size: 15,
              ),
              Text(text)
            ],
          ),
        ),
        onTap: onTap,
      );
    }

//수정중
    Widget _buildRootPostButton() {
      return _buildFamilyPostRow('뿌리 게시물로 가기', () {
        if (Provider.of<PostProvider>(context, listen: false).currentDocId ==
            Provider.of<PostProvider>(context, listen: false).rootPostDID) {
          return null;
        } else {
          Provider.of<PostProvider>(context, listen: false)
              .getPostData(
                  Provider.of<PostProvider>(context, listen: false).rootPostDID)
              .whenComplete(() =>
                  Provider.of<PageNavProvider>(context, listen: false)
                      .goToOtherPage(context, DetailPostPage.pageName));
          Provider.of<PostProvider>(context, listen: false).getChildPostList();
        }
      });
    }

    Widget _buildParentPostButton() {
      return _buildFamilyPostRow('이전 가지 게시물로 가기', () {
        if (Provider.of<PostProvider>(context, listen: false).parentPostDID ==
            null) {
          return null;
        } else {
          Provider.of<PostProvider>(context, listen: false)
              .getPostData(Provider.of<PostProvider>(context, listen: false)
                  .parentPostDID)
              .whenComplete(() =>
                  Provider.of<PageNavProvider>(context, listen: false)
                      .goToOtherPage(context, DetailPostPage.pageName));
          Provider.of<PostProvider>(context, listen: false).getChildPostList();
        }
      });
    }

    Widget _buildUserBox() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        height: size.height * 0.05,
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.05,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${Provider.of<PostProvider>(context).unm}',
              textScaleFactor: 1.2,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }

    Widget _buildImage() {
      return Container(
        margin: EdgeInsets.all(10),
        height: size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    Widget _buildTitle() {
      return Container(
        height: size.height * 0.05,
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.05,
            ),
            Text(
              Provider.of<PostProvider>(context).title,
              textScaleFactor: 1.5,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(icon: Icon(Icons.favorite_outline), onPressed: () {}),
            IconButton(icon: Icon(Icons.bookmark_outline), onPressed: () {})
          ],
        ),
      );
    }

    Widget _buildEditContent() {
      return Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(children: [
          Expanded(
            child: TextFormField(
              controller: contentController,
              expands: true,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '본문을 입력하세요',
              ),
            ),
          ),
        ]),
      );
    }

    Widget _buildContent() {
      return Container(
        width: size.width,
        constraints: BoxConstraints(minHeight: size.height * 0.35),
        child: Text(
          Provider.of<PostProvider>(context).content,
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.2,
          textAlign: TextAlign.left,
        ),
        padding: EdgeInsets.all(size.width * 0.05),
      );
    }

    Widget _buildContentArea() {
      return Column(
        children: [_buildTitle(), _buildContent()],
      );
    }

    Widget _buildCommentBox(width, title, onTap) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[400],
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    }

    Widget _buildAddContent() {
      return InkWell(
        onTap: () {
          Provider.of<PageNavProvider>(context, listen: false)
              .goToOtherPage(context, WritePostPage.pageName);
        },
        child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            height: size.width * 0.2,
            width: size.width * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey[400],
                  offset: Offset(0.0, 2.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Icon(Icons.add)),
      );
    }

    Widget _buildCommentBoxList(postProvider) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: postProvider.childPostList.length,
          itemBuilder: (context, index) {
            return _buildCommentBox(
                size.width * 0.75, postProvider.childPostList[index][2], () {
              postProvider
                  .getPostData(postProvider.childPostList[index][0])
                  .whenComplete(() =>
                      Provider.of<PageNavProvider>(context, listen: false)
                          .goToOtherPage(context, DetailPostPage.pageName));
              postProvider.getChildPostList();
            });
          });
    }

    Widget _buildCommentBoxListArea(postProvider) {
      return Column(children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: size.height * 0.05,
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.05,
              ),
              Text(
                '댓글',
                textScaleFactor: 1.3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '더보기',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        Container(
          height: size.height * 0.2,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              child: Row(
                  children: postProvider.childPostList.isEmpty
                      ? [_buildAddContent()]
                      : [
                          _buildAddContent(),
                          _buildCommentBoxList(postProvider)
                        ])),
        ),
      ]);
    }

    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            physics: isEdit ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            child: Column(
                children: isEdit
                    ? [_buildEditContent()]
                    : [
                        _buildRootPostButton(),
                        _buildParentPostButton(),
                        _buildUserBox(),
                        _buildImage(),
                        _buildContentArea(),
                        Consumer<PostProvider>(
                            builder: (context, postProvider, child) {
                          return _buildCommentBoxListArea(postProvider);
                        })
                      ]),
          ),
        ));
  }
}
