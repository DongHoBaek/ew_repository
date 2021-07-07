import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/repository/user_repo.dart';
import 'package:ttt_project_003/screens/auth_screen.dart';
import 'package:ttt_project_003/screens/profile_screen.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserRepo _userRepo = UserRepo();

    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(_userRepo),
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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>AuthScreen()), (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Padding _drawerHeader(UserRepo _userRepo) {
    return Padding(
      padding: EdgeInsets.only(top: common_xs_gap),
      child: ListTile(
        leading: RoundedAvatar(imageUrl: _userRepo.profileImageUrl),
        title: Text(
          _userRepo.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_userRepo.statusMessage),
      ),
    );
  }
}
