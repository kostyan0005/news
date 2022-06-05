import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/router.dart';

Widget getTestWidgetFromInitialLocation({
  required String initialLocation,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialLocation: initialLocation);

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    ),
  );
}

Widget getTestWidgetFromInitialWidget({
  required Widget initialWidget,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialWidget: Scaffold(body: initialWidget));

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    ),
  );
}

Widget getTestWidgetFromInitialTabIndex({
  required int initialTabIndex,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialTabIndex: initialTabIndex);

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    ),
  );
}
