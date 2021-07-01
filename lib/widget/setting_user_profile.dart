import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/models/image_picker_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';

class SettingUserProfile extends StatefulWidget {
  @override
  _SettingUserProfileState createState() => _SettingUserProfileState();
}

class _SettingUserProfileState extends State<SettingUserProfile> {
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _statusMessageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.5),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<ImagePickerProvider>(
                      builder: (context, imagePickerProvider, child) {
                        return InkWell(
                          onTap: (){
                            imagePickerProvider.pickImage();
                          },
                          child: CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: imagePickerProvider.image != null
                                  ? Image.file(imagePickerProvider.image, fit: BoxFit.cover, width: 100, height: 100,) : Container(color: Colors.grey,),
                            ),
                          )
                        );
                      }
                    ),
                    TextButton(onPressed: (){
                      Provider.of<ImagePickerProvider>(context, listen: false).clearImage();
                    }, child: Text('기본 이미지로 설정', style: TextStyle(color: Colors.black54),)),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                      child: _nicknameTextFormField(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                      child: _statusMessageTextFormField(),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          await Provider.of<ImagePickerProvider>(context, listen: false).uploadImageToFirebaseStorage();

                          Provider.of<UserProvider>(context, listen: false)
                              .updateProfile(_nicknameController.text,
                              _statusMessageController.text, Provider.of<ImagePickerProvider>(context, listen: false).profileImageURL);
                        }
                      },
                      child:
                          Text('확인', style: TextStyle(color: Colors.black87)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        hintStyle: TextStyle(color: Colors.black26),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      validator: (nickname) {
        if (nickname.isEmpty) {
          return '별명 설정을 해주세요';
        } else if (nickname.isNotEmpty) {}
        return null;
      },
    );
  }

  TextFormField _statusMessageTextFormField() {
    return TextFormField(
      controller: _statusMessageController,
      maxLength: 60,
      cursorColor: Colors.black87,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '상태메세지를 입력하세요',
        hintStyle: TextStyle(color: Colors.black26),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}
