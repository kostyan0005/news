import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/home_tab_frame.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/modules/news/widgets/news_list.dart';
import 'package:news/widgets/indicators.dart';

/// The provider of current user's saved news pieces.
final savedNewsStreamProvider = StreamProvider<List<NewsPiece>>(
    (ref) => ref.watch(savedNewsRepositoryProvider).getSavedNewsStream());

/// The page containing the list of all news pieces the current user has saved.
///
/// The pieces are sorted from latest to earliest saved.
class SavedNewsPage extends ConsumerWidget {
  const SavedNewsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeTabFrame(
      title: 'saved_news'.tr(),
      body: ref.watch(savedNewsStreamProvider).when(
            data: (newsPieces) => NewsList(newsPieces),
            loading: () => const LoadingIndicator(),
            error: (_, __) => const ErrorIndicator(),
          ),
    );
  }
}
