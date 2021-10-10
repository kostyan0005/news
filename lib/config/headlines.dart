import 'package:news/utils/rss_utils.dart';

enum Headlines {
  latest,
  local,
  nation,
  world,
  business,
  technology,
  entertainment,
  science,
  sports,
  health,
}

extension HeadlinesExtension on Headlines {
  String get title {
    switch (this) {
      case Headlines.latest:
        return 'Latest';
      case Headlines.local:
        return 'Local';
      case Headlines.nation:
        return 'Ukraine';
      case Headlines.world:
        return 'World';
      case Headlines.business:
        return 'Business';
      case Headlines.technology:
        return 'Technology';
      case Headlines.entertainment:
        return 'Entertainment';
      case Headlines.science:
        return 'Science';
      case Headlines.sports:
        return 'Sports';
      case Headlines.health:
        return 'Health';
    }
  }

  String get url {
    switch (this) {
      case Headlines.latest:
        return getLatestNewsUrl();
      case Headlines.local:
        return getGeoNewsUrl('Kyiv');
      case Headlines.nation:
        return getHeadlineNewsUrl('NATION');
      default:
        return getHeadlineNewsUrl(title.toUpperCase());
    }
  }
}
