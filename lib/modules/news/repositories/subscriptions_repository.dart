import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';

final subscriptionsRepositoryProvider =
    Provider((ref) => SubscriptionsRepository(ref.watch(uidNotifierProvider)));

class SubscriptionsRepository {
  final CollectionReference<SearchQuery> _mySubscriptionsCollectionRef;

  SubscriptionsRepository(String myId)
      : _mySubscriptionsCollectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(myId)
            .collection('subscriptions')
            .withConverter(
              fromFirestore: (snap, _) => SearchQuery.fromJson(snap.data()!),
              toFirestore: (subscription, _) => subscription.toJson()
                ..['subscriptionDate'] = DateTime.now().toIso8601String(),
            );

  Stream<List<SearchQuery>> getSubscriptionsStream() {
    return _mySubscriptionsCollectionRef
        .orderBy('subscriptionDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  Future<bool> isSubscribed(String searchText) async {
    return await _mySubscriptionsCollectionRef
        .doc(searchText.toLowerCase())
        .get()
        .then((doc) => doc.exists);
  }

  Future<void> subscribe(SearchQuery searchQuery) async {
    await _mySubscriptionsCollectionRef
        .doc(searchQuery.text.toLowerCase())
        .set(searchQuery.copyWith(isSubscribed: true));
  }

  Future<void> unsubscribe(String searchText) async {
    await _mySubscriptionsCollectionRef.doc(searchText.toLowerCase()).delete();
  }
}
