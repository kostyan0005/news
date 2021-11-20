import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/headlines_enum.dart';
import 'package:news/core/home/home_tab_frame.dart';
import 'package:news/modules/news/widgets/rss_news_list.dart';
import 'package:news/modules/profile/providers/locale_stream_provider.dart';
import 'package:news/widgets/indicators.dart';

class HeadlineTabsPage extends ConsumerWidget {
  const HeadlineTabsPage();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final headlines = Headlines.values;
    final localeStreamState = watch(localeStreamProvider);

    return DefaultTabController(
      length: headlines.length,
      child: HomeTabFrame(
        title: 'headlines'.tr(),
        appBarBottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            color: Colors.teal,
            height: 35,
            padding: const EdgeInsets.only(
              bottom: 5,
            ),
            child: localeStreamState.maybeWhen(
              data: (locale) => TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  for (final headline in headlines)
                    Text(headline.getTitle(locale))
                ],
              ),
              orElse: () => SizedBox(),
            ),
          ),
        ),
        body: localeStreamState.when(
          data: (locale) => TabBarView(
            children: [
              for (final headline in headlines)
                RssNewsList(headline.getRssUrl(locale))
            ],
          ),
          loading: () => LoadingIndicator(),
          error: (_, __) => ErrorIndicator(),
        ),
      ),
    );
  }
}
