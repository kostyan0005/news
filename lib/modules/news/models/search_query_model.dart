import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_query_model.freezed.dart';
part 'search_query_model.g.dart';

@freezed
class SearchQuery with _$SearchQuery {
  const factory SearchQuery({
    required String text,
    required String languageCode,
    required String countryCode,
    required bool isSubscribed,
  }) = _SearchQuery;

  factory SearchQuery.fromJson(Map<String, dynamic> json) =>
      _$SearchQueryFromJson(json);

  factory SearchQuery.fromSearchText(String searchText) {
    return SearchQuery(
      text: searchText,
      // todo: align with current locale
      languageCode: 'ru',
      countryCode: 'UA',
      isSubscribed: false,
    );
  }
}
