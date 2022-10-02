import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/providers/rss_news_notifier_provider.dart';
import 'package:news/widgets/indicators.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news_list.dart';

/// todo
class RssNewsList extends ConsumerWidget {
  final String rssUrl;

  const RssNewsList(this.rssUrl);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = rssNewsNotifierProvider(rssUrl);

    return ref.watch(provider).when(
          data: (newsPieces) => SmartRefresher(
            controller: ref.watch(provider.notifier).controller,
            onRefresh: () => ref.read(provider.notifier).refresh(),
            header: const _CustomRefresherHeader(),
            child: NewsList(newsPieces),
          ),
          loading: () => const LoadingIndicator(),
          error: () => const ErrorIndicator(),
        );
  }
}

/// todo
class _CustomRefresherHeader extends StatefulWidget {
  const _CustomRefresherHeader();

  @override
  _CustomRefresherHeaderState createState() => _CustomRefresherHeaderState();
}

class _CustomRefresherHeaderState extends State<_CustomRefresherHeader> {
  static const _indicatorVerticalMargin = 20.0;
  static const _indicatorSize = 25.0;
  // subtract a small amount so that displayed circle does not start empty
  static const _indicatorOffset = _indicatorSize - 5;
  static const _headerHeight = _indicatorSize + 2 * _indicatorVerticalMargin;

  static const _canRefreshOffset = 80;
  static const _maxOffset = _canRefreshOffset - _indicatorOffset;

  RefreshStatus? _status = RefreshStatus.idle;
  double? _value = 0;

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: _headerHeight,
      refreshStyle: RefreshStyle.UnFollow,
      completeDuration: Duration.zero,
      onModeChange: (status) => _status = status,
      onOffsetChange: (offset) {
        if (_status == RefreshStatus.idle) {
          setState(() {
            _value = min((offset - _indicatorOffset) / _maxOffset, 1);
          });
        } else if (_status == RefreshStatus.canRefresh) {
          if (_value != 1) {
            setState(() => _value = 1);
          }
        } else if (_value != null) {
          setState(() => _value = null);
        }
      },
      builder: (_, __) => Center(
        child: Container(
          width: _indicatorSize,
          height: _indicatorSize,
          margin: const EdgeInsets.only(top: _indicatorVerticalMargin),
          child: CircularProgressIndicator(
            value: _value,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}
