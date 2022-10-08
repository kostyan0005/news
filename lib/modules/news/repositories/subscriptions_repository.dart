import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/search_query_model.dart';

/// The provider of [SubscriptionsRepository] instance.
///
/// Updates when [uidNotifierProvider] value changes.
final subscriptionsRepositoryProvider = Provider((ref) =>
    SubscriptionsRepository(
        ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

/// The repository responsible for saving/retrieving/removing user's subscriptions.
///
/// The subscription is the news topic to which the user has subscribed.
class SubscriptionsRepository {
  final CollectionReference<SearchQuery> _mySubscriptionsCollectionRef;

  /// Defines the reference to current user's subscriptions collection and the
  /// converter for documents stored inside it.
  SubscriptionsRepository(String myId, FirebaseFirestore firestore)
      : _mySubscriptionsCollectionRef = firestore
            .collection('users')
            .doc(myId)
            .collection('subscriptions')
            .withConverter(
              fromFirestore: (snap, _) => SearchQuery.fromJson(snap.data()!),
              toFirestore: (subscription, _) => subscription.toJson()
                ..['subscriptionDate'] = DateTime.now().toIso8601String(),
            );

  /// Gets the stream of user's subscriptions.
  Stream<List<SearchQuery>> getSubscriptionsStream() {
    return _mySubscriptionsCollectionRef
        .orderBy('subscriptionDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  /// Determines whether the current user is subscribed to the [searchText] topic.
  Future<bool> isSubscribed(String searchText) async {
    return await _mySubscriptionsCollectionRef
        .doc(Uri.encodeComponent(searchText))
        .get()
        .then((doc) => doc.exists);
  }

  /// Subscribes to the particular [searchQuery] (topic).
  Future<void> subscribe(SearchQuery searchQuery) async {
    await _mySubscriptionsCollectionRef
        .doc(Uri.encodeComponent(searchQuery.text))
        .set(searchQuery.copyWith(isSubscribed: true));
  }

  /// Unsubscribes from the [searchText] topic.
  Future<void> unsubscribe(String searchText) async {
    await _mySubscriptionsCollectionRef
        .doc(Uri.encodeComponent(searchText))
        .delete();
  }
}
