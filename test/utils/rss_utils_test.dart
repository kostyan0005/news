import 'package:flutter_test/flutter_test.dart';
import 'package:news/utils/rss_utils.dart';

void main() {
  group('RSS utils', () {
    test('getLatestNewsUrl is working', () {
      expect(
        getLatestNewsUrl('ru_UA'),
        'https://news.google.com/rss?hl=ru&gl=UA&ceid=UA:ru',
      );
      expect(
        getLatestNewsUrl('en_US'),
        'https://news.google.com/rss?hl=en&gl=US&ceid=US:en',
      );
    });

    test('getHeadlineNewsUrl is working', () {
      expect(
        getHeadlineNewsUrl('LATEST', 'ru_UA'),
        'https://news.google.com/rss/headlines/section/topic/LATEST?hl=ru&gl=UA&ceid=UA:ru',
      );
      expect(
        getHeadlineNewsUrl('SCIENCE', 'en_US'),
        'https://news.google.com/rss/headlines/section/topic/SCIENCE?hl=en&gl=US&ceid=US:en',
      );
    });

    test('getSearchQueryNewsUrl is working', () {
      expect(
        getSearchQueryNewsUrl('Франция', 'ru_UA'),
        'https://news.google.com/rss/search?q=Франция&hl=ru&gl=UA&ceid=UA:ru',
      );
      expect(
        getSearchQueryNewsUrl('France', 'en_US'),
        'https://news.google.com/rss/search?q=France&hl=en&gl=US&ceid=US:en',
      );
    });
  });
}
