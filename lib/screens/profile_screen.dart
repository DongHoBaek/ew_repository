import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/firestore_keys.dart';
import 'package:ttt_project_003/constant/screen_size.dart';
import 'package:ttt_project_003/models/user_provider.dart';
import 'package:ttt_project_003/widgets/post_body.dart';
import 'package:ttt_project_003/widgets/rounded_avatar.dart';

class ProfileScreen extends StatefulWidget {
  List<Map<String, dynamic>> postList;
  List<Map<String, dynamic>> bookmarkPostList;
  Map<String, dynamic> userMap;

  ProfileScreen({Key key, this.postList, this.userMap, this.bookmarkPostList})
      : super(key: key);

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
            widget.userMap != null
                ? widget.userMap[KEY_USERUID] ==
                        Provider.of<UserProvider>(context)
                            .userDataMap[KEY_USERUID]
                    ? _tabButtons()
                    : Container()
                : _tabButtons(),
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
            imageUrl: widget.userMap != null
                ? widget.userMap[KEY_PROFILEIMG]
                : userProvider.userDataMap[KEY_PROFILEIMG],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.userMap != null
                ? widget.userMap[KEY_NICKNAME] != null
                    ? widget.userMap[KEY_NICKNAME]
                    : widget.userMap[KEY_USERNAME]
                : userProvider.userDataMap[KEY_NICKNAME] != null
                    ? userProvider.userDataMap[KEY_NICKNAME]
                    : userProvider.userDataMap[KEY_USERNAME],
            style: TextStyle(fontSize: font_l_size),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.userMap != null
                ? widget.userMap[KEY_PROFILEMSG] != null
                    ? widget.userMap[KEY_PROFILEMSG]
                    : '메세지를 입력해주세요.'
                : userProvider.userDataMap[KEY_PROFILEMSG] != null
                    ? userProvider.userDataMap[KEY_PROFILEMSG]
                    : '메세지를 입력해주세요.',
          ),
        ],
      ),
    );
  }

  Row _tabButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: common_gap, right: common_gap / 2),
            child: InkWell(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(10),
                  color: _selectedTab == SelectedTab.left
                      ? Color(0xFF333333)
                      : Colors.white,
                ),

                  child: Center(
                      child: Text(
                    'Upload Posts',
                    style: TextStyle(
                        color: _selectedTab == SelectedTab.left
                            ? Colors.white
                            : Colors.black),
                  ))),
              onTap: () {
                _tabSelected(SelectedTab.left);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: common_gap / 2, right: common_gap),
            child: InkWell(
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: _selectedTab == SelectedTab.right
                        ? Color(0xFF333333)
                        : Colors.white,
                  ),
                  child: Center(
                      child: Text(
                        'Bookmark',
                        style: TextStyle(
                            color: _selectedTab == SelectedTab.right
                                ? Colors.white
                                : Colors.black),
                      ))),
              onTap: () {
                _tabSelected(SelectedTab.right);
              },
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
            child: PostBody(postList: widget.bookmarkPostList),
          ),
        ],
      ),
    ));
  }
}

enum SelectedTab { left, right }
