import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';

// todo: handle the case where user is changed
final subscriptionsStreamProvider = StreamProvider<List<SearchQuery>>((ref) =>
    ref.read(subscriptionsRepositoryProvider).getSubscriptionsStream());
