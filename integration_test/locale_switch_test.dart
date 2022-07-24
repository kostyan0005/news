import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/main_common.dart' as app;
import 'package:news/modules/news/models/headline_enum.dart';
import 'package:news/modules/news/pages/headline_tabs_page.dart';
import 'package:news/modules/profile/pages/locale_selection_page.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('locale switch logic works', testLocaleSwitchLogic);
}

Future<void> testLocaleSwitchLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // get initial locale
  final isRuInitially =
      find.text(Headline.latest.getTitle('ru_UA')).evaluate().isNotEmpty;
  String expectedLocale =
      UserSettingsRepository.getSupportedLocale(isRuInitially);

  // check that expected headline title exists
  expect(find.byType(HeadlineTabsPage), findsOneWidget);
  expect(find.text(Headline.latest.getTitle(expectedLocale)), findsOneWidget);

  // go to locale selection page
  await tester.tap(find.byKey(const ValueKey('profileButton')).hitTestable());
  await tester.pumpAndSettle();
  await tester.tap(find.text('language_region'.tr()));
  await tester.pumpAndSettle();

  // verify that locale check is placed on initial locale tile
  expect(find.byType(LocaleSelectionPage), findsOneWidget);
  expect(find.byKey(_getLocaleCheckKey(expectedLocale)), findsOneWidget);

  // switch expected locale
  expectedLocale = UserSettingsRepository.getSupportedLocale(!isRuInitially);

  // switch actual locale
  await tester.tap(find.text(_getLocaleTileText(expectedLocale)));
  await tester.pumpAndSettle();

  // verify that locale check is placed on switched locale tile
  expect(find.byKey(_getLocaleCheckKey(expectedLocale)), findsOneWidget);

  // snackbar is shown then hidden after 2 sec
  expect(find.byType(SnackBar), findsOneWidget);
  await Future.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle();
  expect(find.byType(SnackBar), findsNothing);

  // go back to headline tabs page
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // check that expected headline title exists
  expect(find.byType(HeadlineTabsPage), findsOneWidget);
  expect(find.text(Headline.latest.getTitle(expectedLocale)), findsOneWidget);
}

ValueKey<String> _getLocaleCheckKey(String locale) =>
    ValueKey(locale == 'ru_UA' ? 'russianCheck' : 'englishCheck');

String _getLocaleTileText(String locale) =>
    locale == 'ru_UA' ? 'Русский (Украина)' : 'English (United States)';
