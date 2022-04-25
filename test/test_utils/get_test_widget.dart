import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/router.dart';

Widget getTestWidget({
  Widget? initialWidget,
  List<Override> overrides = const [],
}) {
  final router = getRouter(initialWidget);

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    ),
  );
}
