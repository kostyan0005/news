import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> loadTranslations({bool onlyEnglish = true}) async {
  await Future.wait([
    _loadTranslationsForLocale('en'),
    if (!onlyEnglish) _loadTranslationsForLocale('ru'),
    initializeDateFormatting('en'),
  ]);
}

Future<void> _loadTranslationsForLocale(String locale) async {
  final content = await File('assets/translations/$locale.json').readAsString();
  final data = jsonDecode(content) as Map<String, dynamic>;

  // load needed translations directly so that we don't need to deal with any
  // wrapper widgets and waiting/pumping in widget tests
  Localization.load(
    Locale(locale),
    translations: Translations(data),
  );
}
