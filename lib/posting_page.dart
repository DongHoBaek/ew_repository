import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/appStateManagement.dart';
import 'models/post.dart';

class PostingPage extends StatefulWidget {
  final String uid;
  final String unm;

  PostingPage(this.uid, this.unm);

  @override
  _PostingPageState createState() => _PostingPageState();
}

class _PostingPageState extends State<PostingPage> {
  final ref = FirebaseFirestore.instance.collection('posts');

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isValidator = false;
  double appBarHeight = AppBar().preferredSize.height;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final String currentDocId = Provider.of<CurrentDocId>(context).currentDocId;
    String rootPostDID;
    if (currentDocId != null) {
      ref.doc(currentDocId).get().then((DocumentSnapshot document) {
        rootPostDID = document.data()["rootPostDID"];
      });
    }
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            toolbarHeight: isValidator ? 100 : appBarHeight,
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: TextFormField(
              validator: (title) {
                if (title.isEmpty) {
                  setState(() {
                    isValidator = true;
                  });
                  return '올바른 제목을 입력하세요';
                } else if (title.isNotEmpty) {
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
                  splashRadius: 0.1,
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      AddPost post = AddPost(
                          titleController.text,
                          contentController.text,
                          widget.uid,
                          widget.unm,
                          rootPostDID,
                          currentDocId);

                      post.addPost();

                      Navigator.pop(context);
                    }
                  }),
              SizedBox(
                width: 20,
              )
            ]),
        body: Container(
          child: Column(children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
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
          ]),
        ),
      ),
    );
  }
}
