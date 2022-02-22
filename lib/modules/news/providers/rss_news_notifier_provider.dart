import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/rss_news_state.dart';
import '../repositories/news_search_repository.dart';

final rssNewsNotifierProvider = StateNotifierProvider.autoDispose
    .family<RssNewsNotifier, RssNewsState, String>((ref, rssUrl) =>
        RssNewsNotifier(ref.read(newsSearchRepositoryProvider), rssUrl));

class RssNewsNotifier extends StateNotifier<RssNewsState> {
  final NewsSearchRepository _newsSearchRepository;
  final String _rssUrl;
  final controller = RefreshController();

  RssNewsNotifier(this._newsSearchRepository, this._rssUrl)
      : super(const Loading()) {
    getRssNews();
  }

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
        Logger().e(e);
      }
    });
  }

  Future<void> refresh() => getRssNews();
}
