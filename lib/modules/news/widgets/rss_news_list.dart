import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/providers/rss_news_notifier_provider.dart';
import 'package:news/widgets/indicators.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news_item_list.dart';

class RssNewsList extends ConsumerWidget {
  final String rssUrl;

  const RssNewsList(this.rssUrl);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rssProvider = rssNewsNotifierProvider(rssUrl);

    return watch(rssProvider).when(
      data: (newsPieces) => SmartRefresher(
        controller: watch(rssProvider.notifier).controller,
        onRefresh: () => context.read(rssProvider.notifier).refresh(),
        header: _CustomRefresherHeader(),
        child: NewsItemList(newsPieces),
      ),
      loading: () => LoadingIndicator(),
      error: () => ErrorIndicator(),
    );
  }
}

class _CustomRefresherHeader extends StatefulWidget {
  const _CustomRefresherHeader();

  @override
  _CustomRefresherHeaderState createState() => _CustomRefresherHeaderState();
}

class _CustomRefresherHeaderState extends State<_CustomRefresherHeader> {
  static const _canRefreshOffset = 80;
  static const _indicatorSize = 25.0;
  static const _indicatorVerticalMargin = 10.0;
  static const _indicatorOffset = _indicatorSize + _indicatorVerticalMargin;
  static const _maxOffset = _canRefreshOffset - _indicatorOffset;
  static const _headerHeight = _indicatorOffset + 25.0;

  RefreshStatus? _status = RefreshStatus.idle;
  double? _value = 0;

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: _headerHeight,
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
          margin: EdgeInsets.only(
            bottom: _indicatorVerticalMargin,
          ),
          child: CircularProgressIndicator(
            value: _value,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}
