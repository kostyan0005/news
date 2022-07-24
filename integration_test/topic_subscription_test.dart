import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/main_common.dart' as app;
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/widgets/news_card.dart';
import 'package:news/modules/news/widgets/subscription_item.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('topic subscription logic works', testTopicSubscriptionLogic);
}

// todo: modify for desktop due to drawer addition
Future<void> testTopicSubscriptionLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // open search page
  await tester.tap(find.byIcon(Icons.search));
  await tester.pumpAndSettle();

  // search for and subscribe to 'Apple' and 'Google' topics
  await _searchForTopicAndSubscribe(tester, 'Apple');
  await _searchForTopicAndSubscribe(tester, 'Google');

  // go back and switch to subscriptions tab
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.subscriptions_outlined));
  await tester.pumpAndSettle();

  // check that two subscriptions are present
  expect(find.byType(SubscriptionsPage), findsOneWidget);
  expect(find.byType(SubscriptionItem), findsNWidgets(2));
  expect(find.text('Apple'), findsOneWidget);
  expect(find.text('Google'), findsOneWidget);

  // remove the first saved item (Apple), which is last in the list
  await tester.tap(find.byIcon(Icons.delete_outlined).last);
  await tester.pumpAndSettle();

  // check that only one subscription is left
  expect(find.byType(SubscriptionItem), findsOneWidget);
  expect(find.text('Apple'), findsNothing);
  expect(find.text('Google'), findsOneWidget);

  // wait for snackbar to hide
  await _waitForSnackBar(tester);

  // open 'Google' topic page
  await tester.tap(find.byType(SubscriptionItem));
  await tester.pumpAndSettle();

  // check that we are already subscribed to this topic
  expect(find.byType(SearchResultsPage), findsOneWidget);
  expect(find.byIcon(Icons.star), findsOneWidget);

  // unsubscribe from it
  await tester.tap(find.byIcon(Icons.star));
  await tester.pumpAndSettle();

  // check that icon is changed to empty star
  expect(find.byIcon(Icons.star), findsNothing);
  expect(find.byIcon(Icons.star_border), findsOneWidget);

  // wait for snackbar to hide
  await _waitForSnackBar(tester);

  // go back to subscriptions page
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // check that no subscriptions are left
  expect(find.byType(SubscriptionsPage), findsOneWidget);
  expect(find.byType(SubscriptionItem), findsNothing);
}

Future<void> _searchForTopicAndSubscribe(
    WidgetTester tester, String topic) async {
  expect(find.byType(SearchTextPage), findsOneWidget);

  // enter topic name into search field
  await tester.enterText(find.byType(TextField), topic);
  await tester.pump();

  // press search button
  await tester.tap(find.text('search'.tr()));
  await tester.pumpAndSettle();

  // check that some results are found for this query
  expect(find.byType(SearchResultsPage), findsOneWidget);
  expect(find.byType(NewsCard).first, findsOneWidget);

  // subscribe to topic
  await tester.tap(find.byIcon(Icons.star_border));
  await tester.pumpAndSettle();

  // check that icon is changed to filled star
  expect(find.byIcon(Icons.star_border), findsNothing);
  expect(find.byIcon(Icons.star), findsOneWidget);

  // wait for snackbar to hide
  await _waitForSnackBar(tester);

  // return to search text page
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // tap text field to request focus before entering further text
  await tester.tap(find.byType(TextField));
  await tester.pump();
}

Future<void> _waitForSnackBar(WidgetTester tester) async {
  // check that snackbar is shown for 2 sec then hidden
  expect(find.byType(SnackBar), findsOneWidget);

  await Future.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  expect(find.byType(SnackBar), findsNothing);
}
