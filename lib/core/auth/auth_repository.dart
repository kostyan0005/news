import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((_) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  bool get isSignedIn => _auth.currentUser != null;
  User get me => _auth.currentUser!;
  String get myId => me.uid;

  Future<void> signInAnonymouslyIfNeeded() async {
    if (!isSignedIn) await _auth.signInAnonymously();
  }
}
