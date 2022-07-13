import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'locale_switch_test.dart';
import 'piece_saving_test.dart';
import 'topic_subscription_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('news piece saving logic works', testPieceSavingLogic);
  testWidgets('topic subscription logic works', testTopicSubscriptionLogic);
  testWidgets('locale switch logic works', testLocaleSwitchLogic);
}
