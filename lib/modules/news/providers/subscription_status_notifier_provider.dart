import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';

/// The provider of [SubscriptionStatusNotifier].
final subscriptionStatusNotifierProvider = StateNotifierProvider.autoDispose
    .family<SubscriptionStatusNotifier, bool, SearchQuery>((ref, query) =>
        SubscriptionStatusNotifier(
            ref.watch(subscriptionsRepositoryProvider), query));

/// The notifier that tracks whether user is subscribed to the topic or not.
class SubscriptionStatusNotifier extends StateNotifier<bool> {
  final SubscriptionsRepository _subscriptionsRepository;
  final SearchQuery _query;

  SubscriptionStatusNotifier(this._subscriptionsRepository, this._query)
      : super(_query.isSubscribed) {
    if (!_query.isSubscribed) {
      _subscriptionsRepository
          .isSubscribed(_query.text)
          .then((isSubscribed) => isSubscribed ? state = isSubscribed : null);
    }
  }

  /// Subscribes to the [_query] topic.
  void subscribe() {
    _subscriptionsRepository.subscribe(_query);
    state = true;
  }

  /// Unsubscribes from the [_query] topic.
  void unsubscribe() {
    _subscriptionsRepository.unsubscribe(_query.text);
    state = false;
  }
}
