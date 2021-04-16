import 'package:flutter/material.dart';
import 'models/post.dart';

class PostingPage extends StatefulWidget {
  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isValidator = false;
  double appBarHeight = AppBar().preferredSize.height;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            toolbarHeight: isValidator ? 100 : appBarHeight,
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: TextFormField(
              validator: (title){
                if(title.isEmpty){
                  setState(() {
                    isValidator = true;
                  });
                  return '올바른 제목을 입력하세요';
                }else if(title.isNotEmpty){
                  setState(() {
                    isValidator = false;
                  });
                }
                return null;
              },
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                hintText: '제목을 입력하세요',
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if(formKey.currentState.validate()){
                      AddPost post = AddPost(titleController.text, contentController.text);

                      post.addPost();

                      Navigator.pop(context);
                    }
                  }),
              SizedBox(
                width: 20,
              )
            ]),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width*0.85,
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
            ),
          ],
        ),
      ),
    );
  }
}
