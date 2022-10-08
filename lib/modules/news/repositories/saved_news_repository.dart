import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

import 'history_repository.dart';

/// The provider of [SavedNewsRepository] instance.
///
/// Updates when [uidNotifierProvider] value changes.
final savedNewsRepositoryProvider = Provider((ref) => SavedNewsRepository(
    ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

/// The repository responsible storing and retrieving the news pieces the user
/// has saved.
class SavedNewsRepository {
  final CollectionReference<NewsPiece?> _mySavedNewsCollectionRef;

  /// Defines the reference to current user's saved news collection and the
  /// converter for documents stored inside it.
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

  /// Gets the stream of user's saved news pieces.
  Stream<List<NewsPiece>> getSavedNewsStream() {
    return _mySavedNewsCollectionRef
        .orderBy('dateSaved', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()!).toList());
  }

  /// Gets the piece with particular [pieceId] from user's saved news collection.
  Future<NewsPiece?> getSavedPiece(String pieceId) {
    return HistoryRepository.getPieceFromCacheThenServer(
        pieceId, _mySavedNewsCollectionRef);
  }

  /// Determines whether the piece with [pieceId] is saved by the current user.
  Future<bool> isPieceSaved(String pieceId) {
    return _mySavedNewsCollectionRef
        .doc(pieceId)
        .get()
        .then((doc) => doc.exists);
  }

  /// Save the news [piece] to user's saved news collection.
  Future<void> savePiece(NewsPiece piece) async {
    await _mySavedNewsCollectionRef
        .doc(piece.id)
        .set(piece.copyWith(isSaved: true));
  }

  /// Remove the piece with [pieceId] from user's saved news collection.
  Future<void> removePiece(String pieceId) async {
    await _mySavedNewsCollectionRef.doc(pieceId).delete();
  }
}
