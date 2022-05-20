import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

import 'history_repository.dart';

final savedNewsRepositoryProvider = Provider((ref) => SavedNewsRepository(
    ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

// todo: test
class SavedNewsRepository {
  final CollectionReference<NewsPiece?> _mySavedNewsCollectionRef;

  SavedNewsRepository(String myId, FirebaseFirestore firestore)
      : _mySavedNewsCollectionRef = firestore
            .collection('users')
            .doc(myId)
            .collection('saved_news')
            .withConverter(
              fromFirestore: (snap, _) =>
                  snap.exists ? NewsPiece.fromJson(snap.data()!) : null,
              toFirestore: (piece, _) => piece!.toJson()
                ..addAll({'dateSaved': DateTime.now().toIso8601String()}),
            );

  Stream<List<NewsPiece>> getSavedNewsStream() {
    return _mySavedNewsCollectionRef
        .orderBy('dateSaved', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()!).toList());
  }

  Future<NewsPiece?> getSavedPiece(String pieceId) =>
      HistoryRepository.getPieceFromCacheThenServer(
          pieceId, _mySavedNewsCollectionRef);

  Future<bool> isPieceSaved(String pieceId) async {
    return await _mySavedNewsCollectionRef
        .doc(pieceId)
        .get()
        .then((doc) => doc.exists);
  }

  Future<void> savePiece(NewsPiece piece) async {
    await _mySavedNewsCollectionRef
        .doc(piece.id)
        .set(piece.copyWith(isSaved: true));
  }

  Future<void> removePiece(String pieceId) async {
    await _mySavedNewsCollectionRef.doc(pieceId).delete();
  }
}
