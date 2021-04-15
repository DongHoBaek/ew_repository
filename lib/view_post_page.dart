import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPostPage extends StatefulWidget {
  DocumentSnapshot docToView;

  ViewPostPage({this.docToView});

  @override
  _ViewPostPageState createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  bool isEdit = false;

  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController =
        TextEditingController(text: widget.docToView.data()['title']);
    contentController =
        TextEditingController(text: widget.docToView.data()['content']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: isEdit ? TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'content',
              ),
            ) : Text(
              titleController.text,
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              isEdit
                  ? IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        setState(() {
                          widget.docToView.reference.update({
                            'title': titleController.text,
                            'content': contentController.text
                          }).whenComplete(() => Navigator.pop(context));
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
                      hintText: 'content',
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
                      Text(
                        widget.docToView.data()['content'],
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ));
  }
}
