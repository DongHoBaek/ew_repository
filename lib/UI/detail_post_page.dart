import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';

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
  bool isEdit = false;
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: Provider
        .of<PostProvider>(context)
        .title);
    TextEditingController contentController = TextEditingController(
        text: Provider
            .of<PostProvider>(context)
            .content);
    Size size = MediaQuery
        .of(context)
        .size;

    Widget _buildSaveButton() {
      return IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            Provider.of<PostProvider>(context, listen: false).updatePost(
                titleController.text, contentController.text);
            Provider.of<PostProvider>(context, listen: false).getPostList(
                false);
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
            return user.uid == Provider.of<PostProvider>(context, listen: false).uid ? [
              _buildPopupMenuItem('편집', () {
                setState(() {
                  isEdit = true;
                });
                Navigator.pop(context);
              }),
              _buildPopupMenuItem('삭제', () {
                Navigator.pop(context);
                Provider.of<PostProvider>(context, listen: false).deletePost();
                Provider.of<PostProvider>(context, listen: false).getPostList(
                    false);
                Navigator.pop(context);
              }),
              _buildPopupMenuItem('익명화', () {
                Navigator.pop(context);
                Provider.of<PostProvider>(context, listen: false)
                    .anonymizationPost();
                Provider.of<PostProvider>(context, listen: false).getPostList(
                    false);
              }),
              _buildPopupMenuItem('신고', () {}),
            ] : [_buildPopupMenuItem('신고', () {}),];
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

    Widget _buildTitle() {
      return Text(
        Provider
            .of<PostProvider>(context)
            .title,
        style: TextStyle(color: Colors.black),
      );
    }

    Widget _buildAppBar() {
      return AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: isEdit ? _buildEditTitle() : _buildTitle(),
          actions: [isEdit ? _buildSaveButton() : _buildPopupMenuButton()]);
    }

    Widget _buildEditContent() {
      return Container(
        width: size.width,
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
        child: Text(
          Provider
              .of<PostProvider>(context)
              .content,
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.5,
          textAlign: TextAlign.left,
        ),
        padding: EdgeInsets.all(size.width * 0.05),
      );
    }

    Widget _buildToolButton(icon, color, onPressed) {
      return IconButton(icon: Icon(icon), color: color, onPressed: onPressed);
    }

    Widget _buildToolBar() {
      return Row(
        children: [
          _buildToolButton(Icons.favorite_outline, Colors.grey, () {}),
          _buildToolButton(Icons.comment_outlined, Colors.grey, () {}),
          Spacer(),
          _buildToolButton(Icons.bookmark_outline, Colors.grey, () {}),
        ],
      );
    }

    Widget _buildCommentBox() {
      return Container(
        width: size.width * 0.35,
        margin: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: ListTile(
          title: Text('CommentTitle'),
          subtitle: Text('CommentContent'),
          onTap: () {},
        ),
      );
    }

    return Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
                flex: 6, child: isEdit ? _buildEditContent() : _buildContent()),
            isEdit ? Container() : Expanded(flex: 1, child: _buildToolBar()),
            isEdit
                ? Container()
                : Expanded(
              flex: 4,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _buildCommentBox();
                  }),
            )
          ],
        ));
  }
}