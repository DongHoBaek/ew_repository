import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/posting_page.dart';

import 'models/appStateManagement.dart';

class ViewPostPage extends StatefulWidget {
  DocumentSnapshot docToView;
  final String uid;
  final String displayName;

  ViewPostPage(this.uid, this.displayName, {this.docToView});

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
  final ref = FirebaseFirestore.instance.collection('posts');

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController =
        TextEditingController(text: widget.docToView.data()['title']);
    contentController =
        TextEditingController(text: widget.docToView.data()['content']);
    if (widget.uid.compareTo(widget.docToView.data()['uid']) == 0) {
      enableEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CurrentDocId>(context, listen: false).setCurrentDocId(widget.docToView.id);

    final String currentDocId = Provider.of<CurrentDocId>(context).currentDocId;

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
                actions: [
                  isEdit
                      ? IconButton(
                      splashRadius: 0.1,
                          icon: Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              if (formKey.currentState.validate()) {
                                widget.docToView.reference.update({
                                  'title': titleController.text,
                                  'content': contentController.text
                                }).whenComplete(() => Navigator.pop(context));
                              }
                            });
                          })
                      : PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) {
                            return enableEdit
                                ? [
                                    PopupMenuItem(
                                        child: TextButton(
                                      child: Text(
                                        '편집',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isEdit = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                    )),
                                    PopupMenuItem(
                                        child: TextButton(
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        widget.docToView.reference
                                            .delete()
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                        Navigator.pop(context);
                                      },
                                    )),
                                    PopupMenuItem(
                                        child: TextButton(
                                      child: Text(
                                        '신고',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {},
                                    )),
                                  ]
                                : [
                                    PopupMenuItem(
                                        child: TextButton(
                                      child: Text('신고',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      onPressed: () {},
                                    )),
                                  ];
                          },
                        ),
                  SizedBox(
                    width: 20,
                  ),
                ]),
            body: isEdit
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
                : Column(
                    children: [
                      Container(
                        child: Text(
                          widget.docToView.data()['content'],
                          textAlign: TextAlign.left,
                        ),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                            top: MediaQuery.of(context).size.width * 0.05),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200]),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                      ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            IconButton(
                              splashRadius: 0.1,
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
                            IconButton(
                                splashRadius: 0.1,
                                icon: Icon(Icons.comment_outlined),
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PostingPage(widget.uid, widget.displayName)));
                                }),
                            Spacer(),
                            IconButton(
                                splashRadius: 0.1,
                                icon: Icon(Icons.bookmark_border_outlined),
                                onPressed: () {}),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            )
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: ref.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Something went wrong'));
                            }
                            return Expanded(
                              child: Container(
                                child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data.docs
                                    .map((DocumentSnapshot document) {
                                  if (currentDocId ==
                                      document.data()['parentPostDID']) {
                                    return Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context).size.width * 0.05, bottom: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.35,
                                        child: new ListTile(
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewPostPage(widget.uid, widget.displayName, docToView: document)))
                                                .then((value)=>Provider.of<CurrentDocId>(context, listen: false).setCurrentDocId(null));
                                          },
                                          title: new Text(
                                              '${document.data()['unm']}\n${document.data()['title']}', overflow: TextOverflow.ellipsis),
                                          subtitle: Text(
                                            document.data()['content'], overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }).toList()),
                              ),
                            );
                          })
                    ],
                  )));
  }
}
