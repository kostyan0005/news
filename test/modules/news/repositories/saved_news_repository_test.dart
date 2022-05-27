import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';

import '../../../test_utils/all.dart';

void main() async {
  late MockAuthRepository authRepository;
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;
  late SavedNewsRepository sut;
  const testUserId = 'test_user_id';

  setUp(() async {
    authRepository = MockAuthRepository();
    when(() => authRepository.myId).thenReturn(testUserId);
    when(() => authRepository.uidStream).thenReturn(const Stream.empty());

    firestore = FakeFirebaseFirestore();
    container = ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(firestore),
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );

    sut = container.read(savedNewsRepositoryProvider);

    await Future.wait([
      for (final newsJson in generateTestJsonList(true))
        firestore
            .collection('users')
            .doc(testUserId)
            .collection('saved_news')
            .doc(newsJson['id'])
            .set(newsJson),
    ]);
  });

  group('SavedNewsRepository', () {
    test('getSavedNewsStream', () {
      // todo
    });

    test('getSavedPiece', () {
      // todo
    });

    test('isPieceSaved', () {
      // todo
    });

    test('savePiece', () {
      // todo
    });

    test('removePiece', () {
      // todo
    });
  });
}
