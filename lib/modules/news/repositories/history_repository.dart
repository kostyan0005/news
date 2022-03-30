import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

final historyRepositoryProvider =
    Provider((ref) => HistoryRepository(ref.watch(uidNotifierProvider)));

class HistoryRepository {
  final CollectionReference<NewsPiece?> _myHistoryCollectionRef;

  HistoryRepository(String myId)
      : _myHistoryCollectionRef = _getHistoryCollectionRef(myId);

  Future<void> addPieceToHistory(NewsPiece piece) async {
    await _myHistoryCollectionRef.doc(piece.id).set(piece);
  }

  Future<NewsPiece?> getPieceFromHistory(String pieceId, String? sharedFrom) =>
      getPieceFromCacheThenServer(
        pieceId,
        sharedFrom != null
            ? _getHistoryCollectionRef(sharedFrom)
            : _myHistoryCollectionRef,
      );

  static CollectionReference<NewsPiece?> _getHistoryCollectionRef(
          String userId) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('history')
          .withConverter(
            fromFirestore: (snap, _) =>
                snap.exists ? NewsPiece.fromJson(snap.data()!) : null,
            toFirestore: (piece, _) => piece!.toJson()
              ..addAll({'lastVisited': DateTime.now().toIso8601String()}),
          );

  static Future<NewsPiece?> getPieceFromCacheThenServer(
      String pieceId, CollectionReference<NewsPiece?> collectionRef) async {
    try {
      // try getting from cache
      final cachedSnap = await collectionRef
          .doc(pieceId)
          .get(const GetOptions(source: Source.cache));

      if (cachedSnap.exists) {
        return cachedSnap.data()!;
      }
    } catch (_) {
      // for some reason error is thrown if not present in cache
    }

    // try getting from server
    return await collectionRef
        .doc(pieceId)
        .get(const GetOptions(source: Source.server))
        .then((snap) => snap.data());
  }
}
