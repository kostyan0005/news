import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/news/models/news_piece_model.dart';

import 'news_card.dart';

class NewsList extends CustomScrollView {
  final List<NewsPiece> newsPieces;

  NewsList(this.newsPieces)
      : super(
          slivers: [
            if (newsPieces.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => NewsCard(newsPieces[index]),
                    childCount: newsPieces.length,
                  ),
                ),
              )
            else
              SliverFillRemaining(
                child: Center(
                  child: SelectableText(
                    'no_news_found'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        );
}
