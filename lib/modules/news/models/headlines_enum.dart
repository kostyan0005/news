import 'package:news/utils/rss_utils.dart';

enum Headlines {
  latest,
  local, // my location
  nation, // Ukraine or US
  world,
  business,
  technology,
  entertainment,
  science,
  sports,
  health,
}

extension HeadlinesExtension on Headlines {
  String get _name => this.toString().substring(10);

  String getTitle(String langCode) {
    switch (this) {
      case Headlines.latest:
        return langCode == 'ru' ? 'Последние' : 'Latest';
      case Headlines.local:
        return langCode == 'ru' ? 'Местные' : 'Local';
      case Headlines.nation:
        return langCode == 'ru' ? 'Украина' : 'U.S.';
      case Headlines.world:
        return langCode == 'ru' ? 'В мире' : 'World';
      case Headlines.business:
        return langCode == 'ru' ? 'Бизнес' : 'Business';
      case Headlines.technology:
        return langCode == 'ru' ? 'Технологии' : 'Technology';
      case Headlines.entertainment:
        return langCode == 'ru' ? 'Развлечения' : 'Entertainment';
      case Headlines.science:
        return langCode == 'ru' ? 'Наука' : 'Science';
      case Headlines.sports:
        return langCode == 'ru' ? 'Спорт' : 'Sports';
      case Headlines.health:
        return langCode == 'ru' ? 'Здоровье' : 'Health';
    }
  }

  String get url {
    switch (this) {
      case Headlines.latest:
        return getLatestNewsUrl();
      case Headlines.local:
        // todo: should be based on my location
        return getGeoNewsUrl('Kyiv');
      default:
        return getHeadlineNewsUrl(_name.toUpperCase());
    }
  }
}
