import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  Future<FirebaseUser> get getUser => _auth.currentUser();
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = authResult.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await getUser;
    assert(user.uid == currentUser.uid);
    print('user registered: $user');
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> loginEmailPass(String email, String password) async {
    AuthResult authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = authResult.user;
    assert(user != null);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await getUser;
    assert(user.uid == currentUser.uid);
    print('user signed in via email: $user');
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    AuthResult authResult = await _auth.signInWithCredential(credential);

    FirebaseUser user = authResult.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await getUser;
    assert(user.uid == currentUser.uid);

    print('google login succeeded: $user');

    updateUserData(currentUser);

    /// not using this right now but keeping around for reference as it may
    /// come in handy down the road
    // if (authResult.additionalUserInfo.isNewUser) {
    //   updateUserData(currentUser);
    //   print('new user...creating DB entry');
    // } else {
    //   print('user has already logged in once');
    // }

    return currentUser;
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference userRef =
        _db.collection('users-shop-demo').document(user.uid);

    final Map<String, dynamic> data = {
      'uid': user.uid,
      'email': user.email,
      // 'setupComplete': false // only use if checking new user
      // 'displayName': user.displayName,
      // 'photoURL': user.photoUrl,
    };

    return userRef.setData(data, merge: true);
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    return _googleSignIn.signOut();
  }
}
