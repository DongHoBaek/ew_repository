import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttt_project_003/UI/login_page.dart';
import 'package:ttt_project_003/models/post_provider.dart';

import 'UI/detail_post_page.dart';
import 'UI/home_page.dart';
import 'UI/user_home_page.dart';
import 'UI/write_post_page.dart';
import 'models/page_nav_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageNavProvider>(
            create: (_) => PageNavProvider()),
        ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider())
      ],
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Firebase load fail'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

                  if (!snapshot.hasData) {
                    return LoginPage();
                  } else {
                    return Consumer<PageNavProvider>(
                        builder: (context, pageNavProvider, child) {
                      return Navigator(
                        pages: [
                          MaterialPage(child: Home()),
                          if (pageNavProvider.currentPage ==
                              WritePostPage.pageName)
                            WritePostPage(),
                          if (pageNavProvider.currentPage ==
                              DetailPostPage.pageName)
                            DetailPostPage(),
                          if (pageNavProvider.currentPage ==
                              UserHomePage.pageName)
                            UserHomePage(),
                        ],
                        onPopPage: (route, result) {
                          if (!route.didPop(result)) return false;
                          return true;
                        },
                      );
                    });
                  }
                });
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
