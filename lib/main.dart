import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/config/routes.dart';
import 'package:news/core/home/home_page.dart';
import 'package:news/utils/custom_ru_messages.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  runApp(MyApp());

  timeago.setLocaleMessages('ru', CustomRuMessages());
  timeago.setDefaultLocale('ru');
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
        initialRoute: HomePage.routeName,
        routes: routes,
      ),
    );
  }
}
