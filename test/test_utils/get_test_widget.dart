import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/router.dart';

Widget getTestWidgetFromInitialLocation({
  required String initialLocation,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialLocation: initialLocation);
  return _getTestWidget(overrides, router);
}

Widget getTestWidgetFromInitialWidget({
  required Widget initialWidget,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialWidget: Scaffold(body: initialWidget));
  return _getTestWidget(overrides, router);
}

Widget getTestWidgetFromInitialTabIndex({
  required int initialTabIndex,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialTabIndex: initialTabIndex);
  return _getTestWidget(overrides, router);
}

Widget _getTestWidget(List<Override> overrides, GoRouter router) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    ),
  );
}
