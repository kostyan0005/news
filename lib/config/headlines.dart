import 'package:easy_localization/easy_localization.dart';
import 'package:news/utils/rss_utils.dart';

enum Headlines {
  latest,
  local, // my location
  nation, // Ukraine or United States
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
  String get title => _name.tr();

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
