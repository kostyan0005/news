const _prefix = 'https://news.google.com/rss';
const _headlinePart = '/headlines/section/topic/';
// const _geoPart = '/headlines/section/geo/';
const _searchPart = '/search?q=';

String _getSuffix(String locale) {
  final localeParts = locale.split('_');
  final langCode = localeParts[0];
  final countryCode = localeParts[1];
  return 'hl=$langCode&gl=$countryCode&ceid=$countryCode:$langCode';
}

// todo: test
String getLatestNewsUrl(String locale) => _prefix + '?' + _getSuffix(locale);
String getHeadlineNewsUrl(String topic, String locale) =>
    _prefix + _headlinePart + topic + '?' + _getSuffix(locale);
String getSearchQueryNewsUrl(String query, String locale) =>
    _prefix + _searchPart + query + '&' + _getSuffix(locale);
