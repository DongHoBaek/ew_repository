import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/screens/auth_screen.dart';
import 'package:ttt_project_003/screens/feed_screen.dart';
import 'package:ttt_project_003/widgets/my_progress_indicator.dart';

import 'constant/screen_size.dart';
import 'models/firebase_auth_state.dart';
import 'models/post_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    PostProvider().getHomePostList();
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return Consumer<FirebaseAuthState>(builder: (BuildContext context,
        FirebaseAuthState firebaseAuthState, Widget child) {
      switch (firebaseAuthState.firebaseAuthStatus) {
        case FirebaseAuthStatus.signout:
          _currentWidget = AuthScreen();
          break;
        case FirebaseAuthStatus.signin:
          _currentWidget = FeedScreen();
          break;
        default:
          _currentWidget = MyProgressIndicator();
      }
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        switchInCurve: Curves.fastOutSlowIn,
        switchOutCurve: Curves.fastOutSlowIn,
        child: _currentWidget,
      );
    });
  }
}
