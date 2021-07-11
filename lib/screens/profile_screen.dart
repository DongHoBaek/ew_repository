import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/widgets/post_body.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';

class ProfileScreen extends StatefulWidget {
  List<Map<String, dynamic>> postList;

  ProfileScreen({Key key, this.postList}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size.width;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            _userProfile(userProvider),
            _tabButtons(),
            _selectedIndicator(),
          ]),
        ),
        _postPager()
      ]),
    );
  }

  Container _userProfile(userProvider) {
    return Container(
      height: size.height * 0.26,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedAvatar(
            size: 100,
            imageUrl: userProvider.profileImage,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            userProvider.nickname != null
                ? userProvider.nickname
                : userProvider.username,
            style: TextStyle(fontSize: font_l_size),
          ),
          SizedBox(
            height: 5,
          ),
          userProvider.profileMessage == ""
              ? Text('메세지를 입력해주세요.')
              : Text(userProvider.profileMessage),
        ],
      ),
    );
  }

  Row _tabButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              color: Colors.grey[200],
              child: IconButton(
                icon: Icon(
                  Icons.post_add,
                  color: _selectedTab == SelectedTab.left
                      ? Colors.black
                      : Colors.black26,
                ),
                onPressed: () {
                  _tabSelected(SelectedTab.left);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              color: Colors.grey[200],
              child: IconButton(
                icon: Icon(
                  Icons.bookmark_outline,
                  color: _selectedTab == SelectedTab.left
                      ? Colors.black26
                      : Colors.black,
                ),
                onPressed: () {
                  _tabSelected(SelectedTab.right);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: 3,
          width: size.width / 2 - 4.0,
          color: Colors.black38,
        ),
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  SliverToBoxAdapter _postPager() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(top: common_s_gap),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
            curve: Curves.fastOutSlowIn,
            child: PostBody(postList: widget.postList),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
            curve: Curves.fastOutSlowIn,
            child: PostBody(postList: widget.postList),
          ),
        ],
      ),
    ));
  }
}

enum SelectedTab { left, right }
