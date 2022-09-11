import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_query_model.freezed.dart';
part 'search_query_model.g.dart';

/// Search query data, including search text and the locale used for the search.
@freezed
class SearchQuery with _$SearchQuery {
  const factory SearchQuery({
    required String text,
    required String locale,
    required bool isSubscribed,
  }) = _SearchQuery;

  factory SearchQuery.fromJson(Map<String, dynamic> json) =>
      _$SearchQueryFromJson(json);
}
