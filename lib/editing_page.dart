import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/home.dart';

class EditingPage extends StatefulWidget {
  DocumentSnapshot docToEdit;

  EditingPage({this.docToEdit});

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    titleController =
        TextEditingController(text: widget.docToEdit.data()['title']);
    contentController =
        TextEditingController(text: widget.docToEdit.data()['content']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'title',
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              indent: 17,
              endIndent: 17,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black38),
                ),
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
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black38)),
                child: IconButton(
                  onPressed: () {
                    widget.docToEdit.reference.update({
                      'title': titleController.text,
                      'content': contentController.text
                    }).whenComplete(() => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home())));
                  },
                  icon: Icon(Icons.save_outlined),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black38)),
                child: IconButton(
                  onPressed: () {
                    widget.docToEdit.reference.delete().whenComplete(() =>
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home())));
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
