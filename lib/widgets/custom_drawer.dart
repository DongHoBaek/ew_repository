import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/models/firebase_auth_state.dart';
import 'package:ttt_project_003/models/post_provider.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/profile_screen.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';
import 'package:ttt_project_003/widgets/setting_user_profile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(),
          Divider(
            color: Colors.black38,
          ),
          ListTile(
            title: Text('My Page'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        postList: Provider.of<PostProvider>(context).myPosts,
                        bookmarkPostList:
                            Provider.of<PostProvider>(context).bookmarkPosts,
                      )));
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              Navigator.pop(context);
              Provider.of<FirebaseAuthState>(context, listen: false).signOut();
            },
          ),
        ],
      ),
    );
  }

  Consumer _drawerHeader() {
    return Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget child) {
      return Padding(
        padding: EdgeInsets.only(top: common_xs_gap),
        child: ListTile(
          leading:
              RoundedAvatar(imageUrl: userProvider.userDataMap[KEY_PROFILEIMG]),
          title: Text(
            userProvider.userDataMap[KEY_NICKNAME] != null
                ? userProvider.userDataMap[KEY_NICKNAME]
                : userProvider.userDataMap[KEY_USERNAME],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: userProvider.userDataMap[KEY_PROFILEMSG] == null
              ? Text('???????????? ??????????????????.')
              : Text(userProvider.userDataMap[KEY_PROFILEMSG]),
          trailing: Icon(
            Icons.edit,
            size: 20,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SettingUserProfile(
                      inputNickname: userProvider.userDataMap[KEY_NICKNAME],
                      inputMessage: userProvider.userDataMap[KEY_PROFILEMSG],
                    )));
          },
        ),
      );
    });
  }
}
