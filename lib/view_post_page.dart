import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/appStateManagement.dart';

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
    Provider.of<CurrentDocId>(context, listen: false).setCurrentDocId(widget.docToView.id);
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
            body: StreamBuilder<QuerySnapshot>(
              stream: ref.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
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
                    : Column(
                        children: [
                          Container(
                            child: Text(
                              widget.docToView.data()['content'],
                              textAlign: TextAlign.left,
                            ),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200]),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.09,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width *0.01,),
                                IconButton(
                                  icon: isFavorite
                                      ? Icon(Icons.favorite, color: Colors.red)
                                      : Icon(Icons.favorite_outline, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                  },
                                ),
                                IconButton(icon: Icon(Icons.comment_outlined), onPressed: (){}),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.51,),
                                IconButton(icon: Icon(Icons.bookmark_border_outlined), onPressed: (){})
                              ],
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: MediaQuery.of(context).size.width * 0.35,
                                    );
                                  }),
                            ),
                          )
                        ],
                      );
              },
            )));
  }
}
