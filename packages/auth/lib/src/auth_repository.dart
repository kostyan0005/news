import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:twitter_login/twitter_login.dart';

final authRepositoryProvider = Provider((_) => AuthRepository());

enum SignInResult { success, failed, cancelled, accountInUse }

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  User get _me => _auth.currentUser!;
  String get myId => _me.uid;

  Stream<User> get userChangesStream =>
      _auth.userChanges().where((u) => u != null).cast<User>();
  Stream<String> get uidStream => userChangesStream.map((u) => u.uid);

  Future<void> signInAnonymouslyIfNeeded() async {
    if (_auth.currentUser == null) await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _auth.signInAnonymously();
  }

  Future<SignInResult> _connectWithCredential(AuthCredential credential) async {
    try {
      await _me.linkWithCredential(credential);
      return SignInResult.success;
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'credential-already-in-use') {
        if (_me.isAnonymous) {
          // user is not signed in yet
          try {
            await _auth.signInWithCredential(credential);
            return SignInResult.success;
          } on FirebaseAuthException catch (e, s) {
            // log an unexpected error
            Logger().e(e.message, e, s);
            return SignInResult.failed;
          }
        } else {
          // user is already singed in with another account
          return SignInResult.accountInUse;
        }
      } else {
        // log unexpected error
        Logger().e(e.message, e, s);
        return SignInResult.failed;
      }
    }
  }

  Future<SignInResult> connectWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return SignInResult.cancelled;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _connectWithCredential(credential);
  }

  Future<SignInResult> connectWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    final status = result.status;

    if (status == LoginStatus.cancelled) {
      return SignInResult.cancelled;
    } else if (status != LoginStatus.success) {
      Logger().e(result.message);
      return SignInResult.failed;
    }

    final credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    return await _connectWithCredential(credential);
  }

  Future<SignInResult> connectWithTwitter(
      String apiKey, String secretKey, String redirectUri) async {
    final twitterLogin = TwitterLogin(
      apiKey: apiKey,
      apiSecretKey: secretKey,
      redirectURI: redirectUri,
    );

    final result = await twitterLogin.login();
    final status = result.status;

    if (status == TwitterLoginStatus.cancelledByUser) {
      return SignInResult.cancelled;
    } else if (status == TwitterLoginStatus.error) {
      Logger().e(result.errorMessage);
      return SignInResult.failed;
    }

    final credential = TwitterAuthProvider.credential(
      accessToken: result.authToken!,
      secret: result.authTokenSecret!,
    );
    return await _connectWithCredential(credential);
  }
}
