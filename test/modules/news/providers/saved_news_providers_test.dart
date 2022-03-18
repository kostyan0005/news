import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/pages/saved_news_page.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/modules/news/widgets/options_sheet.dart';

class MockSavedNewsRepository extends Mock implements SavedNewsRepository {}

void main() {
  late MockSavedNewsRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockSavedNewsRepository();
    container = ProviderContainer(
      overrides: [savedNewsRepositoryProvider.overrideWithValue(repository)],
    );
  });

  final dummyNewsPiece = NewsPiece(
    id: '',
    link: '',
    title: '',
    sourceName: '',
    sourceLink: '',
    pubDate: DateTime.now(),
    isSaved: false,
  );

  test('saved news stream provider states are updated properly', () async {
    when(() => repository.getSavedNewsStream()).thenAnswer((_) async* {
      await Future.delayed(const Duration(milliseconds: 100));
      yield <NewsPiece>[];

      await Future.delayed(const Duration(milliseconds: 100));
      yield [dummyNewsPiece];
    });

    expect(
      container.read(savedNewsStreamProvider),
      const AsyncValue<List<NewsPiece>>.loading(),
    );

    await Future.delayed(const Duration(milliseconds: 110));
    expect(container.read(savedNewsStreamProvider).value?.length, 0);

    await Future.delayed(const Duration(milliseconds: 100));
    expect(container.read(savedNewsStreamProvider).value?.length, 1);
  });

  test('news piece saved status is correct', () async {
    when(() => repository.isPieceSaved('1')).thenAnswer((_) async => false);
    expect(
      container.read(pieceSavedStatusProvider('1')),
      const AsyncValue<bool>.loading(),
    );

    await container.read(pieceSavedStatusProvider('1').future);
    expect(
      container.read(pieceSavedStatusProvider('1')),
      const AsyncValue.data(false),
    );

    when(() => repository.isPieceSaved('2')).thenAnswer((_) async => true);
    await container.read(pieceSavedStatusProvider('2').future);
    expect(
      container.read(pieceSavedStatusProvider('2')),
      const AsyncValue.data(true),
    );
  });
}
