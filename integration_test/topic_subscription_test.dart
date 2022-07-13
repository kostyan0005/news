import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/main_common.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('topic subscription logic works', testTopicSubscriptionLogic);
}

Future<void> testTopicSubscriptionLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // todo
  // go to search results page, subscribe to 2 topics, then go to subscriptions
  // tab, check that 2 topic is present, remove one topic right there, check
  // that 1 is left, open the subscription again to see if it's marked as
  // subscribed, then unsubscribe from it from it's page, check that 0 topics
  // are present in subscriptions
}
