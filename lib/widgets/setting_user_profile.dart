import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/gallery_state.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class SettingUserProfile extends StatefulWidget {
  String inputNickname;
  String inputMessage;

  SettingUserProfile({Key key, this.inputNickname, this.inputMessage})
      : super(key: key);

  @override
  _SettingUserProfileState createState() => _SettingUserProfileState();
}

class _SettingUserProfileState extends State<SettingUserProfile> {
  TextEditingController _nicknameController;
  TextEditingController _statusMessageController;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    GalleryState().clearImage();
    _nicknameController.dispose();
    _statusMessageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nicknameController = TextEditingController(text: widget.inputNickname);
    _statusMessageController = TextEditingController(text: widget.inputMessage);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<GalleryState>(
                    builder: (context, galleryState, child) {
                  return InkWell(
                      onTap: () {
                        galleryState.getImage();
                      },
                      child: CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child: galleryState.image != null
                              ? Image.file(
                                  File(galleryState.image.path),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                )
                              : Container(
                                  color: Colors.grey,
                                ),
                        ),
                      ));
                }),
                TextButton(
                    onPressed: () {
                      Provider.of<GalleryState>(context, listen: false)
                          .clearImage();
                    },
                    child: Text(
                      '기본 이미지로 설정',
                      style: TextStyle(color: Colors.black54),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: _nicknameTextFormField(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                  child: _statusMessageTextFormField(),
                ),
                _submitBtn(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _submitBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          Provider.of<UserProvider>(context, listen: false).updateProfile(
              _nicknameController.text, _statusMessageController.text);

          Navigator.pop(context);
        }
      },
      child: Text('확인', style: TextStyle(color: Colors.black87)),
    );
  }

  TextFormField _nicknameTextFormField() {
    return TextFormField(
      controller: _nicknameController,
      maxLength: 20,
      cursorColor: Colors.black87,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '별명을 입력하세요',
      ),
      validator: (nickname) {
        if (nickname.isEmpty) {
          return '별명을 설정해주세요';
        } else if (nickname.isNotEmpty) {}
        return null;
      },
    );
  }

  TextFormField _statusMessageTextFormField() {
    return TextFormField(
      controller: _statusMessageController,
      maxLength: 60,
      maxLines: null,
      cursorColor: Colors.black87,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '상태메세지를 입력하세요',
      ),
    );
  }
}
