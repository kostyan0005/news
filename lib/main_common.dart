import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'router.dart';
import 'utils/custom_ru_messages.dart';
import 'utils/register_web_webview_stub.dart'
    if (dart.library.html) 'utils/register_web_webview.dart';

void mainCommon({required bool isProd}) async {
  WidgetsFlutterBinding.ensureInitialized();

  EasyLocalization.logger.enableLevels = [
    LevelMessages.error,
    LevelMessages.warning,
  ];

  await Future.wait([
    Firebase.initializeApp(
      options: isProd
          ? prod.DefaultFirebaseOptions.currentPlatform
          : dev.DefaultFirebaseOptions.currentPlatform,
    ),
    EasyLocalization.ensureInitialized(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  // switch to emulators
  // final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  // FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  // await FirebaseAuth.instance.useAuthEmulator(host, 9099);

  // set auth instance and sign in
  AuthRepository.instance.setAuthInstance(FirebaseAuth.instance, isProd);
  await AuthRepository.instance.signInAnonymouslyIfNeeded();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: const RootRestorationScope(
        restorationId: 'root',
        child: App(),
      ),
    ),
  );

  if (Intl.systemLocale.startsWith(RegExp(r'ru|ua'))) {
    timeago.setLocaleMessages('ru', CustomRuMessages());
    timeago.setDefaultLocale('ru');
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // platform-dependent
  registerWebViewWebImplementation();
}

class App extends StatefulWidget {
  const App();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = getRouter();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'News',
        restorationScopeId: 'app',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white.withAlpha(245),
          textTheme: kIsWeb ? GoogleFonts.sourceSansProTextTheme() : null,
        ),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
