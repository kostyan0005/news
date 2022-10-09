const _prefix = 'https://news.google.com/rss';
const _headlinePart = '/headlines/section/topic/';
// const _geoPart = '/headlines/section/geo/';
const _searchPart = '/search?q=';

/// Gets the suffix of the RSS URL link, which defines the relevant country for
/// the fetched news and the language they are in.
///
/// The language and the country of interest are determined from the [locale].
String _getSuffix(String locale) {
  final localeParts = locale.split('_');
  final langCode = localeParts[0];
  final countryCode = localeParts[1];
  return 'hl=$langCode&gl=$countryCode&ceid=$countryCode:$langCode';
}

/// Gets the URL from which the latest news would be fetched.
String getLatestNewsUrl(String locale) => '$_prefix?${_getSuffix(locale)}';

/// Gets the URL from which the news with the particular [topic] would be fetched.
String getHeadlineNewsUrl(String topic, String locale) =>
    '$_prefix$_headlinePart$topic?${_getSuffix(locale)}';

/// Gets the URL from which the news relevant to the particular search [query]
/// would be fetched.
String getSearchQueryNewsUrl(String query, String locale) =>
    '$_prefix$_searchPart$query&${_getSuffix(locale)}';
