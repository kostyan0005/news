import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/history_repository.dart';

import '../../../test_utils/all.dart';

void main() async {
  late MockAuthRepository authRepository;
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;
  late HistoryRepository sut;

  group('HistoryRepository', () {
    setUp(() async {
      authRepository = MockAuthRepository();
      when(() => authRepository.myId).thenReturn(testUserId);
      when(() => authRepository.uidStream)
          .thenAnswer((_) => const Stream.empty());

      firestore = FakeFirebaseFirestore();
      container = ProviderContainer(
        overrides: [
          firestoreProvider.overrideWithValue(firestore),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
      );

      sut = container.read(historyRepositoryProvider);
    });

    Future<bool> isPieceInHistory(String pieceId) {
      return firestore
          .collection('users')
          .doc(testUserId)
          .collection('history')
          .doc(pieceId)
          .get()
          .then((snap) => snap.exists);
    }

    test('addPieceToHistory', () async {
      expect(await isPieceInHistory('0'), false);
      await sut.addPieceToHistory(
          NewsPiece.fromJson(generateTestPieceJson(0, false)));
      expect(await isPieceInHistory('0'), true);
    });

    test('getPieceFromHistory', () async {
      expect(await sut.getPieceFromHistory('0', null), null);
      await sut.addPieceToHistory(
          NewsPiece.fromJson(generateTestPieceJson(0, false)));
      expect(await sut.getPieceFromHistory('0', null),
          isA<NewsPiece>().having((p) => p.id, 'id', '0'));
    });
  });
}
