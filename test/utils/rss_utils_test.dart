import 'package:flutter_test/flutter_test.dart';
import 'package:news/utils/rss_utils.dart';

void main() {
  group('RSS utils test', () {
    test('getLatestNewsUrl test', () {
      expect(getLatestNewsUrl('ru_UA'),
          equals('https://news.google.com/rss?hl=ru&gl=UA&ceid=UA:ru'));
      expect(getLatestNewsUrl('en_US'),
          equals('https://news.google.com/rss?hl=en&gl=US&ceid=US:en'));
    });

    test('getHeadlineNewsUrl test', () {
      expect(
          getHeadlineNewsUrl('LATEST', 'ru_UA'),
          equals(
              'https://news.google.com/rss/headlines/section/topic/LATEST?hl=ru&gl=UA&ceid=UA:ru'));
      expect(
          getHeadlineNewsUrl('SCIENCE', 'en_US'),
          equals(
              'https://news.google.com/rss/headlines/section/topic/SCIENCE?hl=en&gl=US&ceid=US:en'));
    });

    test('getSearchQueryNewsUrl test', () {
      expect(
          getSearchQueryNewsUrl('Франция', 'ru_UA'),
          equals(
              'https://news.google.com/rss/search?q=Франция&hl=ru&gl=UA&ceid=UA:ru'));
      expect(
          getSearchQueryNewsUrl('France', 'en_US'),
          equals(
              'https://news.google.com/rss/search?q=France&hl=en&gl=US&ceid=US:en'));
    });
  });
}
