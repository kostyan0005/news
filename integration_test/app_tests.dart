import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/main_common.dart' as app;

import 'locale_switch_test.dart';
import 'news_saving_test.dart';
import 'topic_subscription_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> launchApp(WidgetTester tester) async {
    await app.mainCommon(isProd: false);
    await tester.pumpAndSettle();
  }

  testWidgets('news saving logic works', (tester) async {
    await launchApp(tester);
    await testNewsSavingLogic(tester);
  });

  testWidgets('topic subscription logic works', (tester) async {
    await launchApp(tester);
    await testTopicSubscriptionLogic(tester);
  });

  testWidgets('locale switch logic works', (tester) async {
    await launchApp(tester);
    await testLocaleSwitchLogic(tester);
  });
}
