import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPostPage extends StatefulWidget {
  DocumentSnapshot docToView;
  final String uid;

  ViewPostPage(this.uid, {this.docToView});

  @override
  _ViewPostPageState createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  bool isFavorite = false;
  bool enableEdit = false;
  bool isEdit = false;
  bool isValidator = false;
  double appBarHeight = AppBar().preferredSize.height;
  final formKey = GlobalKey<FormState>();
  final ref = FirebaseFirestore.instance.collection('comment');

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    titleController =
        TextEditingController(text: widget.docToView.data()['title']);
    contentController =
        TextEditingController(text: widget.docToView.data()['content']);
    super.initState();
    if (widget.uid.compareTo(widget.docToView.data()['uid']) == 0) {
      enableEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Scaffold(
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                toolbarHeight: isValidator ? 100 : appBarHeight,
                elevation: 0.0,
                title: isEdit
                    ? TextFormField(
                        controller: titleController,
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          hintText: '제목을 입력하세요',
                        ),
                      )
                    : Text(
                        titleController.text,
                        style: TextStyle(color: Colors.black),
                      ),
                actions: enableEdit
                    ? [
                        IconButton(
                          icon: isFavorite
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_outline,
                                  color: Colors.black),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                        isEdit
                            ? IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  setState(() {
                                    if (formKey.currentState.validate()) {
                                      widget.docToView.reference.update({
                                        'title': titleController.text,
                                        'content': contentController.text
                                      }).whenComplete(
                                          () => Navigator.pop(context));
                                    }
                                  });
                                })
                            : IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    isEdit = true;
                                  });
                                },
                              ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              widget.docToView.reference
                                  .delete()
                                  .whenComplete(() => Navigator.pop(context));
                            }),
                        SizedBox(
                          width: 20,
                        )
                      ]
                    : [
                        IconButton(
                          icon: isFavorite
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_outline,
                                  color: Colors.black),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ]),
            body: StreamBuilder<QuerySnapshot>(
              stream: ref.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return isEdit
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.85,
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
                      )
                    : Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: ListView(
                            children: [
                              Container(
                                child: Text(
                                  widget.docToView.data()['content'],
                                  textAlign: TextAlign.left,
                                ),
                                height: MediaQuery.of(context).size.height*0.7,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: commentController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            )));
  }
}
