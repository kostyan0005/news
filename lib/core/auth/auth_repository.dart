import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:news/core/auth/account_already_in_use_dialog.dart';

final authRepositoryProvider = Provider((_) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  User get _me => _auth.currentUser!;
  String get myId => _me.uid;
  Stream<User?> get userChangesStream => _auth.userChanges();

  Future<void> signInAnonymouslyIfNeeded() async {
    if (_auth.currentUser == null) await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _auth.signInAnonymously();
  }

  Future<void> connectWithGoogle(BuildContext context) async {
    // trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // authentication flow was aborted
      return;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    try {
      await _me.linkWithCredential(credential);
      print(_me.providerData.first.providerId);
      print(_me.providerData.first.photoURL);
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'credential-already-in-use') {
        if (_me.isAnonymous) {
          // user is not signed in yet
          try {
            await _auth.signInWithCredential(credential);
          } on FirebaseAuthException catch (e, s) {
            Logger().e(e.message, e, s);
          }
        } else {
          showAccountAlreadyInUseDialog(context);
        }
      } else {
        Logger().e(e.message, e, s);
      }
    }
  }
}
