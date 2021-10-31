const _prefix = 'https://news.google.com/rss';
const _headlinePart = '/headlines/section/topic/';
const _geoPart = '/headlines/section/geo/';
const _searchPart = '/search?q=';
// todo: adjust depending on current locale
const _suffix = '?hl=ru&gl=UA&ceid=UA:ru';

String getLatestNewsUrl() => _prefix + _suffix;
String getGeoNewsUrl(String geo) => _prefix + _geoPart + geo + _suffix;
String getHeadlineNewsUrl(String topic) =>
    _prefix + _headlinePart + topic + _suffix;
String getSearchQueryNewsUrl(String query) =>
    _prefix + _searchPart + query + '&' + _suffix.substring(1);
