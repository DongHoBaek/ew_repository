import 'package:flutter/material.dart';
import 'models/post.dart';

class PostingPage extends StatefulWidget {
  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: titleController,
                      validator: (value){
                        if(value.isEmpty) {
                          return '제목을 입력하세요!';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'title',
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                indent: MediaQuery.of(context).size.width*0.05,
                endIndent: MediaQuery.of(context).size.width*0.05,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.85,
                  child: TextFormField(
                    controller: contentController,
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'content',
                    ),
                  ),
                ),
              ),
              Divider(
                indent: MediaQuery.of(context).size.width*0.05,
                endIndent: MediaQuery.of(context).size.width*0.05,
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  if(formKey.currentState.validate()){
                    AddPost post = AddPost(titleController.text, contentController.text);

                    post.addPost();

                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
