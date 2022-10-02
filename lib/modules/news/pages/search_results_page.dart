import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/config/constants.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/providers/subscription_status_notifier_provider.dart';
import 'package:news/modules/news/widgets/rss_news_list.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';
import 'package:news/utils/rss_utils.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:share_plus/share_plus.dart';

/// The page showing news pieces found with the [queryText] search query.
class SearchResultsPage extends ConsumerWidget {
  final String queryText;

  /// The locale in which the search is conducted and results are displayed.
  final String? queryLocale;

  /// The indicator of whether the current user is subscribed to [queryText]
  /// topic or not.
  final bool isSubscribed;

  const SearchResultsPage({
    required this.queryText,
    required this.queryLocale,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        queryLocale ?? ref.watch(userSettingsRepositoryProvider).myLocale;
    final rssUrl = getSearchQueryNewsUrl(queryText, locale);

    final query = SearchQuery(
      text: queryText,
      locale: locale,
      isSubscribed: isSubscribed,
    );

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  queryText,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              centerTitle: true,
              actions: [
                ref.watch(subscriptionStatusNotifierProvider(query))
                    ? _UnsubscribeButton(query)
                    : _SubscribeButton(query),
                IconButton(
                  onPressed: () {
                    final encodedText = Uri.encodeComponent(queryText);
                    final sharedLink =
                        '$kWebsiteUrl/topic/$encodedText?locale=$locale';
                    Share.share('$queryText: $sharedLink');
                  },
                  icon: const Icon(Icons.ios_share),
                ),
              ],
            ),
          ];
        },
        body: RssNewsList(rssUrl),
      ),
    );
  }
}

/// The button to subscribe to the [searchQuery] topic.
class _SubscribeButton extends ConsumerWidget {
  final SearchQuery searchQuery;

  const _SubscribeButton(this.searchQuery);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(subscriptionStatusNotifierProvider(searchQuery).notifier)
            .subscribe();
        showSnackBarMessage(context, 'subscribed_message'.tr());
      },
      icon: const Icon(Icons.star_border),
    );
  }
}

/// The button to unsubscribe from the [searchQuery] topic.
class _UnsubscribeButton extends ConsumerWidget {
  final SearchQuery searchQuery;

  const _UnsubscribeButton(this.searchQuery);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref
            .read(subscriptionStatusNotifierProvider(searchQuery).notifier)
            .unsubscribe();
        showSnackBarMessage(context, 'unsubscribed_message'.tr());
      },
      icon: const Icon(Icons.star),
    );
  }
}
