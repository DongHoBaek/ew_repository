import 'package:flutter/material.dart';

class PostingPage extends StatelessWidget {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posting Page'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('save', style: TextStyle(color: Colors.white, fontSize: 20),))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),onPressed: (){},
                ),
                Flexible(
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'title',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: TextFormField(
                controller: contentController,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'content',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
