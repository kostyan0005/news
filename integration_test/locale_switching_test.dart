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
  testWidgets('locale switching logic works', testLocaleSwitchingLogic);
}

/// Fully tests locale switching logic.
Future<void> testLocaleSwitchingLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // Get initial locale.
  final isRuInitially =
      find.text(Headline.latest.getTitle('ru_UA')).evaluate().isNotEmpty;
  String expectedLocale =
      UserSettingsRepository.getSupportedLocale(isRuInitially);

  // Check that expected headline title exists.
  expect(find.byType(HeadlineTabsPage), findsOneWidget);
  expect(find.text(Headline.latest.getTitle(expectedLocale)), findsOneWidget);

  // Go to locale selection page.
  await tester.tap(find.byKey(const ValueKey('profileButton')).hitTestable());
  await tester.pumpAndSettle();
  await tester.tap(find.text('language_region'.tr()));
  await tester.pumpAndSettle();

  // Verify that locale check is placed on initial locale tile.
  expect(find.byType(LocaleSelectionPage), findsOneWidget);
  expect(find.byKey(_getLocaleCheckmarkKey(expectedLocale)), findsOneWidget);

  // Switch expected locale.
  expectedLocale = UserSettingsRepository.getSupportedLocale(!isRuInitially);

  // Switch actual locale.
  await tester.tap(find.text(_getLocaleTileText(expectedLocale)));
  await tester.pumpAndSettle();

  // Verify that locale check is placed on switched locale tile.
  expect(find.byKey(_getLocaleCheckmarkKey(expectedLocale)), findsOneWidget);

  // Snackbar is shown then hidden after 2 sec.
  expect(find.byType(SnackBar), findsOneWidget);
  await Future.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle();
  expect(find.byType(SnackBar), findsNothing);

  // Go back to headline tabs page.
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // Check that expected headline title exists.
  expect(find.byType(HeadlineTabsPage), findsOneWidget);
  expect(find.text(Headline.latest.getTitle(expectedLocale)), findsOneWidget);
}

/// Gets the key of the checkmark near the [locale] tile on [LocaleSelectionPage].
ValueKey<String> _getLocaleCheckmarkKey(String locale) =>
    ValueKey(locale == 'ru_UA' ? 'russianCheck' : 'englishCheck');

/// Gets the title of the [locale] tile on [LocaleSelectionPage].
String _getLocaleTileText(String locale) =>
    locale == 'ru_UA' ? 'Русский (Украина)' : 'English (United States)';
