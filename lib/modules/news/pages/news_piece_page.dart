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
    .family<NewsPiece?, _Args>((ref, args) => ref
        .watch(historyRepositoryProvider)
        .getPieceFromHistory(args.pieceId, args.sharedFrom));

final savedPieceProvider = FutureProvider.autoDispose
    .family<NewsPiece?, String>((ref, pieceId) =>
        ref.watch(savedNewsRepositoryProvider).getSavedPiece(pieceId));

// todo: test
class NewsPiecePage extends ConsumerWidget {
  final String pieceId;
  final bool fromSaved;
  final String? sharedFrom;

  const NewsPiecePage({
    required this.pieceId,
    required this.fromSaved,
    this.sharedFrom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = fromSaved
        ? savedPieceProvider(pieceId)
        : historyPieceProvider(_Args(pieceId, sharedFrom));

    return Scaffold(
      appBar: AppBar(
        actions: ref.watch(provider).maybeWhen(
              data: (piece) => [
                if (piece != null)
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => showOptionsSheetOnNewsPiecePage(
                      ref: ref,
                      context: context,
                      piece: piece,
                    ),
                  ),
              ],
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

class _Args {
  final String pieceId;
  final String? sharedFrom;

  const _Args(this.pieceId, this.sharedFrom);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Args &&
          pieceId == other.pieceId &&
          sharedFrom == other.sharedFrom;

  @override
  int get hashCode => '$pieceId$sharedFrom'.hashCode;
}
