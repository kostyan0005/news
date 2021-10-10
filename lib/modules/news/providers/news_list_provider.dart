import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/news_search_repository.dart';

final newsListProvider = FutureProvider.autoDispose
    .family<List<NewsPiece>, String>((ref, rssUrl) =>
        ref.read(newsSearchRepositoryProvider).getNewsFromRssUrl(rssUrl));
