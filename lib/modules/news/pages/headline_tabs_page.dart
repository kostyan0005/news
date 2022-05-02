import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/headlines_enum.dart';
import 'package:news/core/home_tab_frame.dart';
import 'package:news/modules/news/widgets/rss_news_list.dart';
import 'package:news/modules/profile/providers/locale_stream_provider.dart';
import 'package:news/widgets/indicators.dart';

class HeadlineTabsPage extends ConsumerStatefulWidget {
  const HeadlineTabsPage();

  @override
  ConsumerState<HeadlineTabsPage> createState() => _HeadlineTabsPageState();
}

class _HeadlineTabsPageState extends ConsumerState<HeadlineTabsPage>
    with RestorationMixin, SingleTickerProviderStateMixin {
  final _selectedIndex = RestorableInt(0);
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: Headlines.values.length,
      vsync: this,
    );
  }

  @override
  String get restorationId => 'headline_tabs_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');

    if (initialRestore && _selectedIndex.value != 0) {
      _tabController.index = _selectedIndex.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    const headlines = Headlines.values;
    final localeStreamState = ref.watch(localeStreamProvider);

    return HomeTabFrame(
      title: 'headlines'.tr(),
      appBarBottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          color: Colors.teal,
          height: 35,
          padding: const EdgeInsets.only(bottom: 5),
          child: localeStreamState.maybeWhen(
            data: (locale) => TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                for (final headline in headlines)
                  Text(headline.getTitle(locale))
              ],
              onTap: (index) {
                if (index != _selectedIndex.value) {
                  _selectedIndex.value = index;
                  _tabController.index = index;
                }
              },
            ),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
      body: localeStreamState.when(
        data: (locale) => TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final headline in headlines)
              RssNewsList(headline.getRssUrl(locale))
          ],
        ),
        loading: () => const LoadingIndicator(),
        error: (_, __) => const ErrorIndicator(),
      ),
    );
  }
}
