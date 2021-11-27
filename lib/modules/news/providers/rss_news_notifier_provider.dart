import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:news/modules/news/models/rss_news_state.dart';
import 'package:news/modules/news/repositories/news_search_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final rssNewsNotifierProvider = StateNotifierProvider.autoDispose
    .family<RssNewsNotifier, RssNewsState, String>((ref, rssUrl) =>
        RssNewsNotifier(ref.read(newsSearchRepositoryProvider), rssUrl));

class RssNewsNotifier extends StateNotifier<RssNewsState> {
  final NewsSearchRepository _newsSearchRepository;
  final String _rssUrl;
  final controller = RefreshController();

  RssNewsNotifier(this._newsSearchRepository, this._rssUrl)
      : super(const Loading()) {
    _getRssNews();
  }

  void refresh() => _getRssNews();

  void _getRssNews() {
    _newsSearchRepository.getNewsFromRssUrl(_rssUrl).then((newsPieces) {
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
}
