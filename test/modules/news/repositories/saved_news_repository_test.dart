import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';

import '../../../test_utils/all.dart';

void main() async {
  late MockAuthRepository authRepository;
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;
  late SavedNewsRepository sut;

  group('SavedNewsRepository', () {
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

      sut = container.read(savedNewsRepositoryProvider);

      await Future.wait([
        for (final newsJson in generateTestPieceJsonList(true))
          firestore
              .collection('users')
              .doc(testUserId)
              .collection('saved_news')
              .doc(newsJson['id'])
              .set(newsJson),
      ]);
    });

    test('getSavedPiece', () async {
      expect(await sut.getSavedPiece('0'), isA<NewsPiece>());
      expect(await sut.getSavedPiece('10'), null);
    });

    test('isPieceSaved', () async {
      expect(await sut.isPieceSaved('0'), true);
      expect(await sut.isPieceSaved('10'), false);
    });

    test('savePiece', () async {
      expect(await sut.isPieceSaved('10'), false);
      await sut.savePiece(NewsPiece.fromJson(generateTestPieceJson(10, true)));
      expect(await sut.isPieceSaved('10'), true);
    });

    test('removePiece', () async {
      expect(await sut.isPieceSaved('0'), true);
      await sut.removePiece('0');
      expect(await sut.isPieceSaved('0'), false);
    });

    test('getSavedNewsStream', () async {
      late List<NewsPiece> items;
      items = await sut.getSavedNewsStream().first;
      expect(items.length, 10);
      expect(items.first.id, '9');

      await sut.savePiece(NewsPiece.fromJson(generateTestPieceJson(10, true)));

      items = await sut.getSavedNewsStream().first;
      expect(items.length, 11);
      expect(items.first.id, '10');

      await sut.removePiece('10');

      items = await sut.getSavedNewsStream().first;
      expect(items.length, 10);
      expect(items.first.id, '9');
    });
  });
}
