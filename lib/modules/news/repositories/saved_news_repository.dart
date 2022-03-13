import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

final savedNewsRepositoryProvider =
    Provider((ref) => SavedNewsRepository(ref.watch(uidNotifierProvider)));

class SavedNewsRepository {
  final CollectionReference<NewsPiece> _mySavedNewsCollectionRef;

  SavedNewsRepository(String myId)
      : _mySavedNewsCollectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(myId)
            .collection('saved_news')
            .withConverter(
              fromFirestore: (snap, _) => NewsPiece.fromJson(snap.data()!),
              toFirestore: (piece, _) => piece.toJson()
                ..addAll({'dateSaved': DateTime.now().toIso8601String()}),
            );

  Stream<List<NewsPiece>> getSavedNewsStream() {
    return _mySavedNewsCollectionRef
        .orderBy('dateSaved', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

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
