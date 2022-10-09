import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/config/constants.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:share_plus/share_plus.dart';

import 'link_view.dart';

/// The family of providers which determine for the particular [pieceId] whether
/// it is currently saved or not.
final pieceSavedStatusProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, pieceId) =>
        ref.read(savedNewsRepositoryProvider).isPieceSaved(pieceId));

/// The bottom sheet which presents the options available for
/// the particular news [piece].
class OptionsSheet extends StatelessWidget {
  final NewsPiece piece;

  const OptionsSheet(this.piece);

  static const height = 224.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (piece.isSaved)
              // The piece comes from saved news.
              _RemoveListTile(piece.id)
            else
              // Get the saved status of the piece.
              Consumer(
                builder: (_, ref, __) =>
                    ref.watch(pieceSavedStatusProvider(piece.id)).maybeWhen(
                          data: (isSaved) => isSaved
                              ? _RemoveListTile(piece.id)
                              : _SaveListTile(piece),
                          orElse: () => _SaveListTile(piece),
                        ),
              ),
            ListTile(
              leading: const Icon(Icons.ios_share),
              title: Text('share'.tr()),
              onTap: () {
                final sharedLink = '$kWebsiteUrl/piece/${piece.id}'
                    '?from=${AuthRepository.instance.myId}';
                Share.share('${piece.title}: $sharedLink');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text('go_to_page'.tr(args: [piece.sourceName])),
              onTap: () {
                Navigator.pop(context);
                context.pushNamed('source', queryParams: {
                  'name': piece.sourceName,
                  'link': piece.sourceLink,
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text('dismiss'.tr()),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// The list tile used for adding the news [piece] to saved news.
class _SaveListTile extends ConsumerWidget {
  final NewsPiece piece;

  const _SaveListTile(this.piece);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.star_border),
      title: Text('save'.tr()),
      onTap: () {
        ref.read(savedNewsRepositoryProvider).savePiece(piece);
        showSnackBarMessage(context, 'saved_message'.tr());
        Navigator.pop(context);
      },
    );
  }
}

/// The list tile used for removing the news piece with [pieceId] from saved news.
class _RemoveListTile extends ConsumerWidget {
  final String pieceId;

  const _RemoveListTile(this.pieceId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.delete_outlined),
      title: Text('remove'.tr()),
      onTap: () {
        ref.read(savedNewsRepositoryProvider).removePiece(pieceId);
        showSnackBarMessage(context, 'unsaved_message'.tr());
        Navigator.pop(context);
      },
    );
  }
}

/// Shows the [OptionsSheet] on the [NewsPiecePage] of the particular news [piece].
void showOptionsSheetOnNewsPiecePage({
  required WidgetRef ref,
  required BuildContext context,
  required NewsPiece piece,
}) async {
  if (kIsWeb) {
    Future.delayed(
      const Duration(milliseconds: 250), // Wait until bottom sheet is shown.
      () => ref.read(webBottomSheetVisibilityProvider.notifier).state = true,
    );
  }

  await showModalBottomSheet(
    context: context,
    builder: (_) => OptionsSheet(piece),
  );

  if (kIsWeb) {
    ref.read(webBottomSheetVisibilityProvider.notifier).state = false;
  }
}
