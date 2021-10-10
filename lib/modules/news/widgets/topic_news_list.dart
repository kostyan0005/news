import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/providers/news_list_provider.dart';
import 'package:news/widgets/indicators.dart';

import 'news_item_list.dart';

class TopicNewsList extends ConsumerWidget {
  final String rssUrl;

  const TopicNewsList(this.rssUrl);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final topicNews = watch(newsListProvider(rssUrl));
    return topicNews.when(
      data: (newsPieces) => NewsItemList(newsPieces),
      loading: () => LoadingIndicator(),
      error: (_, __) => ErrorIndicator(),
    );
  }
}
