import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/pages/subscriptions_page.dart';
import 'package:news/modules/news/providers/subscription_status_notifier_provider.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';

class MockSubscriptionsRepository extends Mock
    implements SubscriptionsRepository {}

void main() {
  late MockSubscriptionsRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockSubscriptionsRepository();
    container = ProviderContainer(
      overrides: [
        subscriptionsRepositoryProvider.overrideWithValue(repository)
      ],
    );
  });

  const subscribedSearchQuery =
      SearchQuery(text: '', locale: '', isSubscribed: true);
  const notSubscribedSearchQuery =
      SearchQuery(text: '', locale: '', isSubscribed: false);

  getStatus(bool isSubscribedInitially) =>
      container.read(subscriptionStatusNotifierProvider(isSubscribedInitially
          ? subscribedSearchQuery
          : notSubscribedSearchQuery));

  getNotifier() => container
      .read(subscriptionStatusNotifierProvider(subscribedSearchQuery).notifier);

  group('subscriptionStatusNotifierProvider', () {
    test('initial status is determined correctly', () {
      when(() => repository.isSubscribed('')).thenAnswer((_) async => false);
      expect(getStatus(false), false);
      expect(getStatus(true), true);
    });

    test('status is properly updated on request', () {
      expect(getStatus(true), true);

      when(() => repository.unsubscribe('')).thenAnswer((_) async {});
      getNotifier().unsubscribe();
      expect(getStatus(true), false);

      when(() => repository.subscribe(subscribedSearchQuery))
          .thenAnswer((_) async {});
      getNotifier().subscribe();
      expect(getStatus(true), true);
    });
  });

  test('subscriptions stream provider states are updated properly', () async {
    when(() => repository.getSubscriptionsStream()).thenAnswer((_) async* {
      await Future.delayed(const Duration(milliseconds: 100));
      yield <SearchQuery>[];

      await Future.delayed(const Duration(milliseconds: 100));
      yield [subscribedSearchQuery];
    });

    expect(
      container.read(subscriptionsStreamProvider),
      const AsyncValue<List<SearchQuery>>.loading(),
    );

    await Future.delayed(const Duration(milliseconds: 110));
    expect(container.read(subscriptionsStreamProvider).value?.length, 0);

    await Future.delayed(const Duration(milliseconds: 100));
    expect(container.read(subscriptionsStreamProvider).value?.length, 1);
  });
}
