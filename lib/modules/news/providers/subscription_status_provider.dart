import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';

// todo: test
final subscriptionStatusProvider = StateNotifierProvider.autoDispose
    .family<SubscriptionStatusNotifier, bool, SearchQuery>((ref, searchQuery) =>
        SubscriptionStatusNotifier(
            ref.read(subscriptionsRepositoryProvider), searchQuery));

class SubscriptionStatusNotifier extends StateNotifier<bool> {
  final SubscriptionsRepository _subscriptionsRepository;
  final SearchQuery _searchQuery;

  SubscriptionStatusNotifier(this._subscriptionsRepository, this._searchQuery)
      : super(_searchQuery.isSubscribed) {
    if (!_searchQuery.isSubscribed) {
      _subscriptionsRepository
          .isSubscribed(_searchQuery.text)
          .then((isSubscribed) => isSubscribed ? state = isSubscribed : null);
    }
  }

  void subscribe() {
    _subscriptionsRepository.subscribe(_searchQuery);
    state = true;
  }

  void unsubscribe() {
    _subscriptionsRepository.unsubscribe(_searchQuery.text);
    state = false;
  }
}
