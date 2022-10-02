import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/modules/news/models/headline_enum.dart';
import 'package:news/core/home_tab_frame.dart';
import 'package:news/modules/news/widgets/rss_news_list.dart';
import 'package:news/modules/profile/providers/locale_stream_provider.dart';
import 'package:news/widgets/indicators.dart';

/// The page that consists of a tab bar with different news categories as tabs.
///
/// State restoration is implemented for this page.
class HeadlineTabsPage extends ConsumerStatefulWidget {
  const HeadlineTabsPage();

  @override
  ConsumerState<HeadlineTabsPage> createState() => _HeadlineTabsPageState();
}

class _HeadlineTabsPageState extends ConsumerState<HeadlineTabsPage>
    with RestorationMixin, SingleTickerProviderStateMixin {
  late final _controller =
      TabController(length: Headline.values.length, vsync: this);
  final _selectedIndex = RestorableInt(0);

  @override
  String get restorationId => 'HeadlineTabsPage';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selectedIndex');

    if (initialRestore && _selectedIndex.value != 0) {
      _controller.index = _selectedIndex.value;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _controller,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                for (final headline in Headline.values)
                  Text(
                    headline.getTitle(locale),
                    style: kIsWeb ? GoogleFonts.roboto() : null,
                  ),
              ],
              onTap: (index) {
                if (index != _controller.index) {
                  _controller.index = index;
                  _selectedIndex.value = index;
                }
              },
            ),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
      body: localeStreamState.when(
        data: (locale) => TabBarView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final headline in Headline.values)
              RssNewsList(headline.getRssUrl(locale))
          ],
        ),
        loading: () => const LoadingIndicator(),
        error: (_, __) => const ErrorIndicator(),
      ),
    );
  }
}
