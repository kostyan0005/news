import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:news/core/auth/account_already_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';

final authRepositoryProvider = Provider((_) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  User get _me => _auth.currentUser!;
  String get myId => _me.uid;
  Stream<User?> get userChangesStream => _auth.userChanges();

  Future<void> signInAnonymouslyIfNeeded() async {
    if (_auth.currentUser == null) await _auth.signInAnonymously();
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await _auth.signInAnonymously();
    showSnackBarMessage(context, 'You\'ve been signed out');
  }

  void _showUnexpectedErrorMessage(BuildContext context) =>
      showSnackBarErrorMessage(
          context,
          'An unexpected error has occurred. Please try '
          'again later or connect with another account.');

  Future<void> _connectWithCredential(AuthCredential credential,
      BuildContext context, String providerName) async {
    late bool success;

    try {
      await _me.linkWithCredential(credential);
      success = true;
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'credential-already-in-use') {
        if (_me.isAnonymous) {
          // user is not signed in yet
          try {
            await _auth.signInWithCredential(credential);
            success = true;
          } on FirebaseAuthException catch (e, s) {
            // log an unexpected error
            Logger().e(e.message, e, s);
            success = false;
          }
        } else {
          // user is already singed in with another account
          showAccountAlreadyInUseDialog(context);
          return;
        }
      } else {
        // log an unexpected error
        Logger().e(e.message, e, s);
        success = false;
      }
    }

    if (success) {
      showSnackBarMessage(context, 'You\'ve been connected with $providerName');
    } else {
      _showUnexpectedErrorMessage(context);
    }
  }

  Future<void> connectWithGoogle(BuildContext context) async {
    // trigger authentication flow
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // authentication flow was aborted
      return;
    }

    // create credential from access and id tokens
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // connect to firebase with above credential
    await _connectWithCredential(credential, context, 'Google');
  }

  Future<void> connectWithFacebook(BuildContext context) async {
    // trigger authentication flow
    final loginResult = await FacebookAuth.instance.login();
    final loginStatus = loginResult.status;

    if (loginStatus == LoginStatus.cancelled) {
      // authentication flow was aborted
      return;
    } else if (loginStatus != LoginStatus.success) {
      Logger().e(loginResult.message);
      _showUnexpectedErrorMessage(context);
      return;
    }

    // create credential from access token
    final credential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // connect to firebase with above credential
    await _connectWithCredential(credential, context, 'Facebook');
  }
}
