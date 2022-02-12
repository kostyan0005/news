// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIeNdaMUvgPqlSP9R3rEBZjNl90mLxPyU',
    appId: '1:174952535817:android:8bbabdaaea579efb35e5d8',
    messagingSenderId: '174952535817',
    projectId: 'news-dev-1',
    storageBucket: 'news-dev-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBL1b4YjljH4xAx9LoK-KNhJRFwUjt4YIc',
    appId: '1:174952535817:ios:7f9a68592bc8e39635e5d8',
    messagingSenderId: '174952535817',
    projectId: 'news-dev-1',
    storageBucket: 'news-dev-1.appspot.com',
    androidClientId: '174952535817-kh39g1dhkd6pnp6dma7fshas6r8590nv.apps.googleusercontent.com',
    iosClientId: '174952535817-c1klmop72mc8ouf4h4poqr3ht9m0bbhi.apps.googleusercontent.com',
    iosBundleId: 'com.kostiar.news.dev',
  );
}