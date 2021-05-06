import 'package:flutter/material.dart';

class WritePostPage extends Page {
  static final String pageName = 'WritePostPage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => WritePost());
  }
}

class WritePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WritePostPage'),
      ),
    );
  }
}


// Form(
//   key: formKey,
//   child: Scaffold(
//     appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         toolbarHeight: isValidator ? 100 : appBarHeight,
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         title: TextFormField(
//           validator: (title) {
//             if (title.isEmpty) {
//               setState(() {
//                 isValidator = true;
//               });
//               return '올바른 제목을 입력하세요';
//             } else if (title.isNotEmpty) {
//               setState(() {
//                 isValidator = false;
//               });
//             }
//             return null;
//           },
//           controller: titleController,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.red),
//             ),
//             hintText: '제목을 입력하세요',
//           ),
//         ),
//         actions: [
//           IconButton(
//               splashRadius: 0.1,
//               icon: Icon(Icons.check),
//               onPressed: () {
//                 if (formKey.currentState.validate()) {
//                   AddPost post = AddPost(
//                       titleController.text,
//                       contentController.text,
//                       widget.uid,
//                       widget.unm,
//                       rootPostDID,
//                       currentDocId);
//
//                   post.addPost();
//
//                   Navigator.pop(context);
//                 }
//               }),
//           SizedBox(
//             width: 20,
//           )
//         ]),
//     body: Container(
//       child: Column(children: [
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: TextFormField(
//               controller: contentController,
//               expands: true,
//               maxLines: null,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: '본문을 입력하세요',
//               ),
//             ),
//           ),
//         ),
//       ]),
//     ),
//   ),
// );
