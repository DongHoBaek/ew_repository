import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.signout;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;
  GoogleSignIn _googleSignIn;

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;

  User get user => _user;

  void signInWithGoogle() async {
    if (_googleSignIn == null) _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User user = userCredential.user;

    if (user == null) {
    } else {
      _user = user;
      changeFirebaseAuthStatus(FirebaseAuthStatus.signin);
    }

    notifyListeners();
  }

  void signOut() async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_user != null) {
      _user = null;
      await _firebaseAuth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    }
    notifyListeners();
  }

  void watchAuthChange() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null && _user == null) {
        changeFirebaseAuthStatus(FirebaseAuthStatus.signout);
      } else if (user != _user) {
        _user = user;
        changeFirebaseAuthStatus(FirebaseAuthStatus.signin);
      }
    });
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseAuthStatus != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }

    notifyListeners();
  }
}

enum FirebaseAuthStatus { signout, progress, signin }
