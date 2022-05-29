import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/pages/saved_news_page.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/modules/news/widgets/options_sheet.dart';

import '../../../test_utils/all.dart';

void main() {
  late MockSavedNewsRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockSavedNewsRepository();
    container = ProviderContainer(
      overrides: [savedNewsRepositoryProvider.overrideWithValue(repository)],
    );
  });

  test('saved news stream provider states are updated properly', () async {
    when(() => repository.getSavedNewsStream()).thenAnswer((_) async* {
      await Future.delayed(const Duration(milliseconds: 100));
      yield <NewsPiece>[];

      await Future.delayed(const Duration(milliseconds: 100));
      yield [NewsPiece.fromJson(generateTestPieceJson(0, true))];

      await Future.delayed(const Duration(milliseconds: 100));
      throw Exception();
    });

    verifyNever(() => repository.getSavedNewsStream());
    expect(container.read(savedNewsStreamProvider).isLoading, true);

    await Future.delayed(const Duration(milliseconds: 120));
    expect(container.read(savedNewsStreamProvider).value?.length, 0);

    await Future.delayed(const Duration(milliseconds: 120));
    expect(container.read(savedNewsStreamProvider).value?.length, 1);

    await Future.delayed(const Duration(milliseconds: 120));
    expect(container.read(savedNewsStreamProvider).hasError, true);

    verify(() => repository.getSavedNewsStream()).called(1);
  });

  test('news piece saved status is correct', () async {
    when(() => repository.isPieceSaved('1')).thenAnswer((_) async => false);
    expect(container.read(pieceSavedStatusProvider('1')).isLoading, true);

    await container.read(pieceSavedStatusProvider('1').future);
    expect(container.read(pieceSavedStatusProvider('1')).value, false);

    when(() => repository.isPieceSaved('2')).thenAnswer((_) async => true);
    await container.read(pieceSavedStatusProvider('2').future);
    expect(container.read(pieceSavedStatusProvider('2')).value, true);

    when(() => repository.isPieceSaved('3'))
        .thenAnswer((_) async => throw Exception());
    try {
      await container.read(pieceSavedStatusProvider('3').future);
    } catch (_) {}
    expect(container.read(pieceSavedStatusProvider('3')).hasError, true);

    verify(() => repository.isPieceSaved('1')).called(1);
    verify(() => repository.isPieceSaved('2')).called(1);
    verify(() => repository.isPieceSaved('3')).called(1);
  });
}
