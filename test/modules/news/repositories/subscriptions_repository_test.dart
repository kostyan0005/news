import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';

import '../../../test_utils/all.dart';

void main() async {
  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;
  late SubscriptionsRepository sut;

  group('HistoryRepository', () {
    setUp(() async {
      firestore = FakeFirebaseFirestore();
      await addTestSubscriptionsToFirestore(firestore);

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );

      sut = container.read(subscriptionsRepositoryProvider);
    });

    test('isSubscribed', () async {
      expect(await sut.isSubscribed('0'), true);
      expect(await sut.isSubscribed('10'), false);
    });

    test('subscribe', () async {
      expect(await sut.isSubscribed('10'), false);
      await sut
          .subscribe(SearchQuery.fromJson(generateTestSubscriptionJson(10)));
      expect(await sut.isSubscribed('10'), true);
    });

    test('unsubscribe', () async {
      expect(await sut.isSubscribed('0'), true);
      await sut.unsubscribe('0');
      expect(await sut.isSubscribed('0'), false);
    });

    test('getSubscriptionsStream', () async {
      late List<SearchQuery> items;
      items = await sut.getSubscriptionsStream().first;
      expect(items.length, 10);
      expect(items.first.text, '9');

      await sut
          .subscribe(SearchQuery.fromJson(generateTestSubscriptionJson(10)));

      items = await sut.getSubscriptionsStream().first;
      expect(items.length, 11);
      expect(items.first.text, '10');

      await sut.unsubscribe('10');

      items = await sut.getSubscriptionsStream().first;
      expect(items.length, 10);
      expect(items.first.text, '9');
    });
  });
}
