import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:news/core/auth/account_already_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:twitter_login/twitter_login.dart';

final authRepositoryProvider = Provider((_) => AuthRepository());

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
        // log unexpected error
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
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await _connectWithCredential(credential, context, 'Google');
  }

  Future<void> connectWithFacebook(BuildContext context) async {
    final result = await FacebookAuth.instance.login();
    final status = result.status;

    if (status == LoginStatus.cancelled) {
      return;
    } else if (status != LoginStatus.success) {
      Logger().e(result.message);
      _showUnexpectedErrorMessage(context);
      return;
    }

    final credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    await _connectWithCredential(credential, context, 'Facebook');
  }

  Future<void> connectWithTwitter(BuildContext context) async {
    final twitterLogin = TwitterLogin(
        apiKey: '5GmPG67Y0HUNTLEPHdUGU7wbw',
        apiSecretKey: 'FiT1tYYfXkJzD2Vxz5z0B1qWL7SEGCGC7JgkoSXUtquhtHOUqH',
        redirectURI: 'example://');

    final result = await twitterLogin.login();
    final status = result.status;

    if (status == TwitterLoginStatus.cancelledByUser) {
      return;
    } else if (status == TwitterLoginStatus.error) {
      Logger().e(result.errorMessage);
      _showUnexpectedErrorMessage(context);
      return;
    }

    final credential = TwitterAuthProvider.credential(
        accessToken: result.authToken!, secret: result.authTokenSecret!);
    await _connectWithCredential(credential, context, 'Twitter');
  }
}
