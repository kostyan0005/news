import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

/// The provider of [HistoryRepository] instance.
///
/// Updates when [uidNotifierProvider] value changes.
final historyRepositoryProvider = Provider((ref) => HistoryRepository(
    ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

/// The repository responsible for saving and retrieving news pieces from user's
/// view history.
class HistoryRepository {
  final FirebaseFirestore _firestore;
  final CollectionReference<NewsPiece?> _myHistoryCollectionRef;

  HistoryRepository(String myId, this._firestore)
      : _myHistoryCollectionRef = _getHistoryCollectionRef(myId, _firestore);

  /// Adds the [piece] viewed by the current user to the view history.
  Future<void> addPieceToHistory(NewsPiece piece) async {
    await _myHistoryCollectionRef.doc(piece.id).set(piece);
  }

  /// Gets the piece with [pieceId] from user's view history.
  ///
  /// If [sharedFrom] is specified, get the piece from the history of the user
  /// from whom this piece is shared.
  Future<NewsPiece?> getPieceFromHistory(String pieceId, String? sharedFrom) {
    return getPieceFromCacheThenServer(
      pieceId,
      sharedFrom != null
          ? _getHistoryCollectionRef(sharedFrom, _firestore)
          : _myHistoryCollectionRef,
    );
  }

  /// Gets the reference to the view history collection of the user with [userId].
  static CollectionReference<NewsPiece?> _getHistoryCollectionRef(
          String userId, FirebaseFirestore firestore) =>
      firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .withConverter(
            fromFirestore: (snap, _) =>
                snap.exists ? NewsPiece.fromJson(snap.data()!) : null,
            toFirestore: (piece, _) => piece!.toJson()
              ..addAll({'lastVisited': DateTime.now().toIso8601String()}),
          );

  /// Try to get the news piece with [pieceId] from the particular [collectionRef].
  ///
  /// First tries to get this piece from cache, and if not there, then tries to
  /// find it in the server database.
  static Future<NewsPiece?> getPieceFromCacheThenServer(
      String pieceId, CollectionReference<NewsPiece?> collectionRef) async {
    try {
      // Try getting from cache.
      final cachedSnap = await collectionRef
          .doc(pieceId)
          .get(const GetOptions(source: Source.cache));

      if (cachedSnap.exists) {
        return cachedSnap.data()!;
      }
    } catch (_) {
      // For some reason error is thrown if not present in cache.
    }

    // Try getting from server.
    return await collectionRef
        .doc(pieceId)
        .get(const GetOptions(source: Source.server))
        .then((snap) => snap.data());
  }
}
