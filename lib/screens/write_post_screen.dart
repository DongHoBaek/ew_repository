import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/gallery_state.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/detail_post_screen.dart';
import 'package:ttt_project_003/screens/feed_screen.dart';
import 'package:ttt_project_003/widgets/header.dart';
import 'package:ttt_project_003/widgets/my_progress_indicator.dart';

class WritePostScreen extends StatefulWidget {
  String imageUrl;
  String inputTitle;
  String inputContent;

  WritePostScreen({Key key, this.imageUrl, this.inputTitle, this.inputContent})
      : super(key: key);

  @override
  _WritePostScreenState createState() {
    return _WritePostScreenState();
  }
}

class _WritePostScreenState extends State<WritePostScreen> {
  String _title = 'Create New Post';

  bool _loading = false;

  TextEditingController _titleController;

  TextEditingController _contentController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    GalleryState().clearImage();
    UserProvider().getUserData();
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    widget.inputTitle != null ? _title = "" : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _titleController = TextEditingController(text: widget.inputTitle);
    _contentController = TextEditingController(text: widget.inputContent);

    return IgnorePointer(
      ignoring: _loading ? true : false,
      child: Scaffold(
          appBar: AppBar(
            title: Text(_title),
          ),
          body: Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: common_gap),
                    child: Container(
                      height: size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Header(text: 'Image', padding: 0.0),
                          _imageBox(),
                          Header(text: 'Title', padding: 0.0),
                          _titleField(),
                          Header(text: 'Content', padding: 0.0),
                          Expanded(child: _contentField()),
                          _submitBtn(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _loading
                  ? Container(
                      height: size.height,
                      width: size.width,
                      child: MyProgressIndicator())
                  : Container()
            ],
          )),
    );
  }

  Padding _submitBtn(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: common_gap),
        child: TextButton(
          child: Text(
            '등록',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue, minimumSize: Size(size.width, 50)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              print('Validation success!!');
              setState(() {
                widget.inputTitle = _titleController.text;
                widget.inputContent = _contentController.text;
                _loading = true;
              });
              if (_title == "") {
                Provider.of<PostProvider>(context, listen: false)
                    .updatePost(_titleController.text, _contentController.text)
                    .whenComplete(() async {
                  await Provider.of<PostProvider>(context, listen: false)
                      .getPostData(
                          Provider.of<PostProvider>(context, listen: false)
                              .currentDocId);
                  await Provider.of<PostProvider>(context, listen: false)
                      .getHomePostList();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailPostScreen(
                              postMap: Provider.of<PostProvider>(context)
                                  .currentPostMap)),
                      (route) => route is FeedScreen);
                });
              } else {
                Provider.of<PostProvider>(context, listen: false)
                    .createPost(_titleController.text, _contentController.text,
                        DateTime.now())
                    .whenComplete(() {
                  Provider.of<PostProvider>(context, listen: false)
                      .getHomePostList();
                  Navigator.pop(context);
                });
              }
            }
          },
        ));
  }

  TextFormField _contentField() {
    return TextFormField(
      controller: _contentController,
      cursorColor: Colors.grey[700],
      expands: true,
      maxLines: null,
      validator: (text) {
        if (text.isNotEmpty) {
          return null;
        } else {
          return '내용을 입력해주세요';
        }
      },
    );
  }

  TextFormField _titleField() {
    return TextFormField(
      controller: _titleController,
      cursorColor: Colors.grey[700],
      validator: (text) {
        if (text.isNotEmpty) {
          return null;
        } else {
          return '제목을 입력해주세요';
        }
      },
    );
  }

  Consumer _imageBox() {
    return Consumer<GalleryState>(builder:
        (BuildContext context, GalleryState galleryState, Widget child) {
      return InkWell(
          onTap: () {
            galleryState.getImage();
          },
          child: Container(
            height: 200,
            width: size.width,
            color: Colors.grey[100],
            child: galleryState.image != null
                ? Image.file(
                    File(galleryState.image.path),
                    fit: BoxFit.cover,
                  )
                : widget.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.add,
                        size: 60,
                        color: Colors.white,
                      ),
          ));
    });
  }
}
