import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/page_nav_provider.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class WritePostPage extends Page {
  static final String pageName = 'WritePostPage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => WritePost());
  }
}

class WritePost extends StatefulWidget {
  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void checkButtonPressed() {
      if (_formKey.currentState.validate()) {
        Provider.of<PostProvider>(context, listen: false).createPost(titleController.text, contentController.text,
            Provider.of<UserProvider>(context, listen: false).uid,
            Provider.of<UserProvider>(context, listen: false).name);
        Provider.of<PostProvider>(context, listen: false).getPostList(false);
        Provider.of<PageNavProvider>(context, listen: false).goBack();
      }
    }

    Widget _buildAppBar(checkButtonPressed) {
      return AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            border: InputBorder.none,
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            hintText: '제목을 입력하세요',
          ),
          validator: (title) {
            if (title.isEmpty) {
              return '올바른 제목을 입력하세요';
            } else if (title.isNotEmpty) {}
            return null;
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: checkButtonPressed,
          ),
          SizedBox(
            width: size.width * 0.05,
          )
        ],
      );
    }

    Widget _buildBody() {
      return Container(
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

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: _buildAppBar(checkButtonPressed),
        body: _buildBody(),
      ),
    );
  }
}
