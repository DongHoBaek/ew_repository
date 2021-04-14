import 'package:flutter/material.dart';
import 'models/post.dart';

class PostingPage extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

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
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black38)),
              child: IconButton(
                onPressed: () {
                  AddPost post = AddPost(titleController.text, contentController.text);

                  post.addPost();

                  Navigator.pop(context);
                },
                icon: Icon(Icons.save_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
