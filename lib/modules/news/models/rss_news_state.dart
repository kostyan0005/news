import 'package:freezed_annotation/freezed_annotation.dart';

import 'news_piece_model.dart';

part 'rss_news_state.freezed.dart';

/// The current state of the news fetching process.
///
/// Includes 3 constant constructors representing the possible states.
@freezed
class RssNewsState with _$RssNewsState {
  const factory RssNewsState.data(List<NewsPiece> newsPieces) = Data;
  const factory RssNewsState.loading() = Loading;
  const factory RssNewsState.error() = Error;
}
