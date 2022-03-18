import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

final historyRepositoryProvider =
    Provider((ref) => HistoryRepository(ref.watch(uidNotifierProvider)));

class HistoryRepository {
  final CollectionReference<NewsPiece?> _myHistoryCollectionRef;

  HistoryRepository(String myId)
      : _myHistoryCollectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(myId)
            .collection('history')
            .withConverter(
              fromFirestore: (snap, _) =>
                  snap.exists ? NewsPiece.fromJson(snap.data()!) : null,
              toFirestore: (piece, _) => piece!.toJson()
                ..addAll({'lastVisited': DateTime.now().toIso8601String()}),
            );

  Future<NewsPiece?> getPieceFromHistory(String pieceId) async {
    // try getting from cache
    final cachedSnap = await _myHistoryCollectionRef
        .doc(pieceId)
        .get(const GetOptions(source: Source.cache));

    if (cachedSnap.exists) {
      return cachedSnap.data()!;
    }

    // try getting from server
    return await _myHistoryCollectionRef
        .doc(pieceId)
        .get(const GetOptions(source: Source.server))
        .then((snap) => snap.data());
  }

  Future<void> addPieceToHistory(NewsPiece piece) async {
    await _myHistoryCollectionRef.doc(piece.id).set(piece);
  }
}
