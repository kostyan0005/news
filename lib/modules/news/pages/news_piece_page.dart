import 'dart:io';

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

/// The family of providers of the piece taken from user's piece history.
///
/// [_Args] class is used as a family argument.
final historyPieceProvider = FutureProvider.autoDispose
    .family<NewsPiece?, _Args>((ref, args) => ref
        .watch(historyRepositoryProvider)
        .getPieceFromHistory(args.pieceId, args.sharedFrom));

/// The family of providers of the piece taken from user's saved piece collection.
final savedPieceProvider = FutureProvider.autoDispose
    .family<NewsPiece?, String>((ref, pieceId) =>
        ref.watch(savedNewsRepositoryProvider).getSavedPiece(pieceId));

/// The page displaying the particular news piece with [pieceId].
///
/// Web view is used for displaying the news piece via its link.
class NewsPiecePage extends ConsumerWidget {
  final String pieceId;

  /// The indicator of whether this piece comes from current user's saved news list.
  final bool fromSaved;

  /// The id of the user from whom this piece is shared.
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
              if (!Platform.environment.containsKey('FLUTTER_TEST')) {
                Logger().e(e, e, s);
              }
              return const ErrorIndicator();
            },
          ),
    );
  }
}

/// The class serving as the argument for [historyPieceProvider] provider family.
///
/// Created to pass multiple variables as one argument to the provider family.
/// An alternative would be to concatenated these multiple variable into one string,
/// but the current solution seems better to the author of this repository.
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
