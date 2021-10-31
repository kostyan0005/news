import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

import 'news_item.dart';

class NewsItemList extends StatelessWidget {
  final List<NewsPiece> newsPieces;

  const NewsItemList(this.newsPieces);

  @override
  Widget build(BuildContext context) {
    return newsPieces.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => NewsItem(newsPieces[index]),
                    childCount: newsPieces.length,
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Text('no_news_found'.tr()),
          );
  }
}
