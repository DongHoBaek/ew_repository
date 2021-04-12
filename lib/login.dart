import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWidget extends StatelessWidget {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final AccessToken result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 100, bottom: 100),
              child: Text('Toward\nthe\ntruth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Oranienbaum',
                    fontSize: 70,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            TextButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: _buildButtonRow(
                    Colors.white, 'assets/google_logo.png', 'Google login'),
                style: TextButton.styleFrom(backgroundColor: Colors.black)
            ),
            SizedBox(height: 10,),
            TextButton(
                onPressed: () {
                  signInWithFacebook();
                },
                child: _buildButtonRow(Colors.white, 'assets/facebook_logo.png', 'Facebook login'),
                style: TextButton.styleFrom(backgroundColor: Colors.blue)
            )
          ],
        ),
      ),
    );
  }

  Container _buildButtonRow(Color color, String image, String label) {
    return Container(
      width: 300,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10,),
          Image(image: AssetImage(image), width: 40, fit: BoxFit.fill,
            color: color
          ),
          Container(
            padding: EdgeInsets.only(left: 60),
            child: Text(label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: color,
                )),
          )
        ],
      ),
    );
  }
}
