import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/history_repository.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/modules/news/widgets/link_view.dart';
import 'package:news/modules/news/widgets/options_sheet.dart';
import 'package:news/widgets/indicators.dart';

final historyPieceProvider = FutureProvider.autoDispose
    .family<NewsPiece?, String>((ref, pieceId) =>
        ref.watch(historyRepositoryProvider).getPieceFromHistory(pieceId));

final savedPieceProvider = FutureProvider.autoDispose
    .family<NewsPiece?, String>((ref, pieceId) =>
        ref.watch(savedNewsRepositoryProvider).getSavedPiece(pieceId));

class NewsPiecePage extends ConsumerWidget {
  final String id;
  final bool fromSaved;

  const NewsPiecePage({
    required this.id,
    required this.fromSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        fromSaved ? savedPieceProvider(id) : historyPieceProvider(id);

    return Scaffold(
      appBar: AppBar(
        actions: ref.watch(provider).maybeWhen(
              data: (piece) => piece != null
                  ? [
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => OptionsSheet(piece),
                        ),
                        icon: const Icon(Icons.more_horiz),
                      ),
                    ]
                  : null,
              orElse: () => null,
            ),
      ),
      body: ref.watch(provider).when(
            data: (piece) => piece != null
                ? LinkView(piece.link)
                : Center(
                    child: Text(
                      'piece_not_found'.tr(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
            loading: () => const LoadingIndicator(),
            error: (e, s) {
              Logger().e(e, e, s);
              return const ErrorIndicator();
            },
          ),
    );
  }
}
