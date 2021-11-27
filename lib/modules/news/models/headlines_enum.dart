import 'package:news/utils/rss_utils.dart';

enum Headlines {
  latest,
  nation, // Ukraine or USA
  world,
  business,
  technology,
  entertainment,
  science,
  sports,
  health,
}

extension HeadlinesExtension on Headlines {
  String get _name => toString().substring(10);

  String getTitle(String locale) {
    final isRu = locale.startsWith('ru');

    switch (this) {
      case Headlines.latest:
        return isRu ? 'Последние' : 'Latest';
      case Headlines.nation:
        return isRu ? 'Украина' : 'U.S.';
      case Headlines.world:
        return isRu ? 'В мире' : 'World';
      case Headlines.business:
        return isRu ? 'Бизнес' : 'Business';
      case Headlines.technology:
        return isRu ? 'Технологии' : 'Technology';
      case Headlines.entertainment:
        return isRu ? 'Развлечения' : 'Entertainment';
      case Headlines.science:
        return isRu ? 'Наука' : 'Science';
      case Headlines.sports:
        return isRu ? 'Спорт' : 'Sports';
      case Headlines.health:
        return isRu ? 'Здоровье' : 'Health';
    }
  }

  String getRssUrl(String locale) {
    switch (this) {
      case Headlines.latest:
        return getLatestNewsUrl(locale);
      default:
        return getHeadlineNewsUrl(_name.toUpperCase(), locale);
    }
  }
}
