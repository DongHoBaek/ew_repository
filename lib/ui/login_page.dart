import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget _buildButtonRow() {
      return TextButton(
        onPressed: () {
          signInWithGoogle();
        },
        child: Container(
          width: size.width * 0.6,
          height: size.height * 0.08,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              CircleAvatar(
                child: Image(
                  image: AssetImage('assets/google_logo.png'),
                  color: Colors.white,
                ),
                radius: size.width * 0.05,
                backgroundColor: Colors.red,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'google login',
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image(
              image: AssetImage('assets/launcher_icon.png'),
            ),
            SizedBox(height: size.height*0.12,),
            _buildButtonRow(),
            SizedBox(height: size.height*0.1,)
          ],
        ),
      ),
    );
  }
}
