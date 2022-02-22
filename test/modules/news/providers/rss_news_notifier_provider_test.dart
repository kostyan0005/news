import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/models/rss_news_state.dart';
import 'package:news/modules/news/providers/rss_news_notifier_provider.dart';
import 'package:news/modules/news/repositories/news_search_repository.dart';

class MockNewsSearchRepository extends Mock implements NewsSearchRepository {}

void main() {
  late MockNewsSearchRepository repository;
  late ProviderContainer container;

  Future<List<NewsPiece>> getNews() => repository.getNewsFromRssUrl('');
  RssNewsState getState() => container.read(rssNewsNotifierProvider(''));
  Future<void> getRssNews() =>
      container.read(rssNewsNotifierProvider('').notifier).getRssNews();

  setUp(() {
    repository = MockNewsSearchRepository();
    container = ProviderContainer(
      overrides: [newsSearchRepositoryProvider.overrideWithValue(repository)],
    );
  });

  group('RSS news notifier provider', () {
    test('initial state is correct', () {
      when(getNews).thenAnswer((_) async => []);
      expect(getState(), equals(const Loading()));
    });

    test('data is received properly', () async {
      when(getNews).thenAnswer((_) async => []);
      await getRssNews();
      expect(getState(), equals(const Data([])));
    });

    test('error state in case of error', () async {
      when(getNews).thenAnswer((_) async => throw Exception());
      await getRssNews();
      expect(getState(), equals(const Error()));
    });

    test('refresh is working', () async {
      when(getNews).thenAnswer((_) async => []);
      await getRssNews();
      expect(getState(), equals(const Data([])));

      // change response
      when(getNews).thenAnswer((_) async => throw Exception());
      // refresh
      await container.read(rssNewsNotifierProvider('').notifier).refresh();
      // now expect the error
      expect(getState(), equals(const Error()));
    });
  });
}
