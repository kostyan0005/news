import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/home/home_tab_frame.dart';
import 'package:news/modules/news/providers/saved_news_stream_provider.dart';
import 'package:news/modules/news/widgets/news_item_list.dart';
import 'package:news/widgets/indicators.dart';

class SavedNewsPage extends ConsumerWidget {
  const SavedNewsPage();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return HomeTabFrame(
      title: 'Saved news',
      body: watch(savedNewsStreamProvider).when(
        data: (newsPieces) => NewsItemList(newsPieces),
        loading: () => LoadingIndicator(),
        error: (_, __) => ErrorIndicator(),
      ),
    );
  }
}
