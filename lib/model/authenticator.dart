import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskshare/model/model.dart';

enum AccountState { loading, signedOut, signedIn, signingIn, singingOut }

class User {
  User({
    @required this.id,
    @required this.imageUrl,
  });

  User.fromFirUser(
    FirebaseUser user,
  ) : this(id: user.uid, imageUrl: Uri.parse(user.photoUrl));

  final String id;
  final Uri imageUrl;
}

abstract class Authenticator {
  ValueObservable<User> get user;
  ValueObservable<AccountState> get state;
  Future<User> signIn();
  Future<void> signOut();
}

class GoogleAuthenticator implements Authenticator {
  GoogleAuthenticator() {
    _auth.onAuthStateChanged.map((user) {
      logger.info('onAuthStateChanged: $user');
      _state.add(user == null ? AccountState.signedOut : AccountState.signedIn);
      return user == null ? null : User.fromFirUser(user);
    }).pipe(_user);
  }

  @override
  ValueObservable<User> get user => _user.stream;

  @override
  ValueObservable<AccountState> get state => _state.stream;
  final _user = BehaviorSubject<User>();

  final _state = BehaviorSubject<AccountState>.seeded(AccountState.loading);

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  Future<User> signIn() async {
    assert(_state.value == AccountState.signedOut);
    _state.add(AccountState.signingIn);
    final gAccount = await _googleSignIn.signIn();
    final gAuth = await gAccount.authentication;
    final res = await _auth.signInWithCredential(
      GoogleAuthProvider.getCredential(
        idToken: gAuth.idToken,
        accessToken: gAuth.accessToken,
      ),
    );
    logger.info(res.user);
    return User.fromFirUser(res.user);
  }

  @override
  Future<void> signOut() async {
    assert(_state.value == AccountState.signedIn);
    _state.add(AccountState.singingOut);
    // TEMP: 本当は呼ぶけど開発中はコメントアウト
//    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  void dispose() {
    _user.close();
    _state.close();
  }
}
