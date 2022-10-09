import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/main_common.dart' as app;
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/widgets/news_card.dart';
import 'package:news/modules/news/widgets/subscription_card.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('topic subscription logic works', testTopicSubscriptionLogic);
}

/// Fully tests topic subscription logic.
Future<void> testTopicSubscriptionLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // Open search page.
  await tester.tap(find.byIcon(Icons.search).hitTestable());
  await tester.pumpAndSettle();

  // Search for and subscribe to 'Apple' and 'Google' topics.
  await _searchForTopicAndSubscribe(tester, 'Apple');
  await _searchForTopicAndSubscribe(tester, 'Google');

  // Go back and switch to subscriptions tab.
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
  if (kIsWeb) {
    // Open drawer on web.
    await tester.tapAt(const Offset(0, 0));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byIcon(Icons.subscriptions_outlined));
  await tester.pumpAndSettle();

  // Check that two subscriptions are present.
  expect(find.byType(SubscriptionsPage), findsOneWidget);
  expect(find.byType(SubscriptionCard), findsNWidgets(2));
  expect(find.text('Apple'), findsOneWidget);
  expect(find.text('Google'), findsOneWidget);

  // Remove the first saved item (Apple), which is last in the list.
  await tester.tap(find.byIcon(Icons.delete_outlined).last);
  await tester.pumpAndSettle();

  // Check that only one subscription is left.
  expect(find.byType(SubscriptionCard), findsOneWidget);
  expect(find.text('Apple'), findsNothing);
  expect(find.text('Google'), findsOneWidget);

  // Wait for snackbar to hide.
  await _waitForSnackBar(tester);

  // Open 'Google' topic page.
  await tester.tap(find.byType(SubscriptionCard));
  await tester.pumpAndSettle();

  // Check that we are already subscribed to this topic.
  expect(find.byType(SearchResultsPage), findsOneWidget);
  expect(find.byIcon(Icons.star), findsOneWidget);

  // Unsubscribe from it.
  await tester.tap(find.byIcon(Icons.star));
  await tester.pumpAndSettle();

  // Check that icon is changed to empty star.
  expect(find.byIcon(Icons.star), findsNothing);
  expect(find.byIcon(Icons.star_border), findsOneWidget);

  // Wait for snackbar to hide.
  await _waitForSnackBar(tester);

  // Go back to subscriptions page.
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // Check that no subscriptions are left.
  expect(find.byType(SubscriptionsPage), findsOneWidget);
  expect(find.byType(SubscriptionCard), findsNothing);
}

/// Searches for the topic with particular [topicName] and subscribes to it.
Future<void> _searchForTopicAndSubscribe(
    WidgetTester tester, String topicName) async {
  expect(find.byType(SearchTextPage), findsOneWidget);

  // Enter topic name into search field.
  await tester.enterText(find.byType(TextField), topicName);
  await tester.pump();

  // Press search button.
  await tester.tap(find.text('search'.tr()));
  await tester.pumpAndSettle();

  // Check that some results are found for this query.
  expect(find.byType(SearchResultsPage), findsOneWidget);
  expect(find.byType(NewsCard).first, findsOneWidget);

  // Subscribe to topic.
  await tester.tap(find.byIcon(Icons.star_border));
  await tester.pumpAndSettle();

  // Check that icon is changed to filled star.
  expect(find.byIcon(Icons.star_border), findsNothing);
  expect(find.byIcon(Icons.star), findsOneWidget);

  // Wait for snackbar to hide.
  await _waitForSnackBar(tester);

  // Return to search text page.
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // Tap text field to request focus before entering further text.
  await tester.tap(find.byType(TextField));
  await tester.pump();
}

/// Checks that snackbar is shown for 2 sec then hidden.
Future<void> _waitForSnackBar(WidgetTester tester) async {
  expect(find.byType(SnackBar), findsOneWidget);

  await Future.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  expect(find.byType(SnackBar), findsNothing);
}
