import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/providers/subscription_status_provider.dart';
import 'package:news/modules/news/widgets/topic_news_list.dart';
import 'package:news/utils/rss_utils.dart';
import 'package:news/utils/snackbar_utils.dart';

class SearchQueryPage extends StatelessWidget {
  const SearchQueryPage();

  static const routeName = '/searchQueryPage';

  @override
  Widget build(BuildContext context) {
    final searchQuery =
        ModalRoute.of(context)!.settings.arguments as SearchQuery;
    final rssUrl = getSearchQueryNewsUrl(searchQuery.text, searchQuery.locale);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  searchQuery.text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              centerTitle: true,
              actions: [
                Consumer(
                    builder: (_, watch, __) =>
                        watch(subscriptionStatusProvider(searchQuery))
                            ? _UnsubscribeButton(searchQuery)
                            : _SubscribeButton(searchQuery)),
              ],
            ),
          ];
        },
        body: TopicNewsList(rssUrl),
      ),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  final SearchQuery searchQuery;

  const _SubscribeButton(this.searchQuery);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context
            .read(subscriptionStatusProvider(searchQuery).notifier)
            .subscribe();
        showSnackBarMessage(context, 'subscribed_message'.tr());
      },
      icon: Icon(Icons.star_border),
    );
  }
}

class _UnsubscribeButton extends StatelessWidget {
  final SearchQuery searchQuery;

  const _UnsubscribeButton(this.searchQuery);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context
            .read(subscriptionStatusProvider(searchQuery).notifier)
            .unsubscribe();
        showSnackBarMessage(context, 'unsubscribed_message'.tr());
      },
      icon: Icon(Icons.star),
    );
  }
}
