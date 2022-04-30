import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder findByIcon(IconData icon) =>
    find.byWidgetPredicate((widget) => widget is Icon && widget.icon == icon);

Finder findByText(String text) =>
    find.byWidgetPredicate((widget) => widget is Text && widget.data == text);

Finder findByTextFragment(String fragment) => find.byWidgetPredicate(
    (widget) => widget is Text && widget.data?.contains(fragment) == true);
