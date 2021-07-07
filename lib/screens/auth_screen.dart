
import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/screen_size.dart';

import 'feed_screen.dart';


class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: AssetImage('assets/icons/launcher_icon.png'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _googleLoginBtn(context),
                  SizedBox(
                    height: 70,
                    width: size.width,
                  )
                ],
              )
            ],
          )),
    );
  }

  TextButton _googleLoginBtn(context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => FeedScreen()),
            (Route<dynamic> route) => false);
      },
      child: Container(
        width: size.width * 0.65,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: Colors.black87, width: 0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 30,
              image: AssetImage('assets/icons/google_logo.png'),
            ),
            SizedBox(
              width: common_xxs_gap,
            ),
            Text(
              'Sign in with Google',
              textScaleFactor: 1.3,
              style: TextStyle(color: Colors.grey[850]),
            ),
          ],
        ),
      ),
    );
  }
}
