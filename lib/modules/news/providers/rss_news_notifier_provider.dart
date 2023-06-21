import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:news/modules/news/models/rss_news_state.dart';
import 'package:news/modules/news/repositories/news_search_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// The provider of [RssNewsNotifier].
final rssNewsNotifierProvider = StateNotifierProvider.autoDispose
    .family<RssNewsNotifier, RssNewsState, String>((ref, rssUrl) =>
        RssNewsNotifier(ref.read(newsSearchRepositoryProvider), rssUrl));

/// The notifier of the current news fetching state changes.
///
/// Also updates the state of refresh [controller].
class RssNewsNotifier extends StateNotifier<RssNewsState> {
  final NewsSearchRepository _newsSearchRepository;
  final String _rssUrl;
  final controller = RefreshController();

  RssNewsNotifier(this._newsSearchRepository, this._rssUrl)
      : super(const Loading()) {
    getRssNews();
  }

  /// Requests the new portion of news and updates the state based on the result.
  Future<void> getRssNews() async {
    await _newsSearchRepository.getNewsFromRssUrl(_rssUrl).then((newsPieces) {
      if (mounted) {
        state = Data(newsPieces);
        controller.refreshCompleted();
      }
    }).catchError((e) {
      if (mounted) {
        state = const Error();
        controller.refreshFailed();

        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          Logger().e(e, e, StackTrace.current);
        }
      }
    });
  }

  /// Refreshes fetched news.
  Future<void> refresh() => getRssNews();
}
