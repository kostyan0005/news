import 'dart:io';

import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/config/routes.dart';
import 'package:news/core/home/home_page.dart';
import 'package:news/utils/custom_ru_messages.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EasyLocalization.logger.enableLevels = [
    LevelMessages.error,
    LevelMessages.warning
  ];

  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    EasyLocalization.ensureInitialized(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  // switch to emulator
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  AuthRepository.instance.setAuthInstance(FirebaseAuth.instance);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: MyApp(),
    ),
  );

  if (Intl.systemLocale.startsWith(RegExp(r'ru|ua'))) {
    timeago.setLocaleMessages('ru', CustomRuMessages());
    timeago.setDefaultLocale('ru');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'News',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white.withAlpha(245),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: HomePage.routeName,
        routes: routes,
      ),
    );
  }
}
