import 'package:flutter/material.dart';

class EditingPage extends StatelessWidget {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editing Page'),
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
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'title',
              ),
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
