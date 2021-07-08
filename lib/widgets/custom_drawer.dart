import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/models/firebase_auth_state.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/screens/profile_screen.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';

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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ProfileScreen()));
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
          leading: RoundedAvatar(imageUrl: userProvider.profileImage),
          title: Text(
            userProvider.username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(userProvider.profileMessage),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
      );
    });
  }
}
