import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/config/headlines.dart';
import 'package:news/core/home/home_tab_frame.dart';
import 'package:news/modules/news/widgets/topic_news_list.dart';

class HeadlineTabsPage extends StatelessWidget {
  const HeadlineTabsPage();

  @override
  Widget build(BuildContext context) {
    final headlines = Headlines.values;
    return DefaultTabController(
      length: headlines.length,
      child: HomeTabFrame(
        title: 'headlines'.tr(),
        appBarBottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            height: 35,
            color: Colors.teal,
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [for (final headline in headlines) Text(headline.title)],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            for (final headline in headlines) TopicNewsList(headline.url)
          ],
        ),
      ),
    );
  }
}
