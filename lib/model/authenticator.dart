import 'package:taskshare/model/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Authenticator {
  Future<FirebaseUser> signIn();
  Future<void> signOut();
}

class GoogleAuthenticator implements Authenticator {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Future<FirebaseUser> signIn() async {
    final gAccount = await _googleSignIn.signIn();
    final gAuth = await gAccount.authentication;
    final firUser = _auth.signInWithGoogle(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );
    print(firUser);
    return firUser;
  }

  @override
  Future<void> signOut() async => _auth.signOut();
}
