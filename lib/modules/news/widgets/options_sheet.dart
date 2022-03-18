import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:share_plus/share_plus.dart';

final pieceSavedStatusProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, pieceId) =>
        ref.read(savedNewsRepositoryProvider).isPieceSaved(pieceId));

class OptionsSheet extends StatelessWidget {
  final NewsPiece piece;

  const OptionsSheet(this.piece);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (piece.isSaved)
            // piece comes from saved news
            _RemoveInkWell(piece.id)
          else
            // get piece's saved status
            Consumer(
              builder: (_, ref, __) =>
                  ref.watch(pieceSavedStatusProvider(piece.id)).maybeWhen(
                        data: (isSaved) => isSaved
                            ? _RemoveInkWell(piece.id)
                            : _SaveInkWell(piece),
                        orElse: () => _SaveInkWell(piece),
                      ),
            ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Share.share(piece.title + ': ' + piece.link);
            },
            child: ListTile(
              leading: const Icon(Icons.ios_share),
              title: Text('share'.tr()),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('source', queryParams: {
                'name': piece.sourceName,
                'link': piece.sourceLink,
              });
            },
            child: ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text('go_to_page'.tr(args: [piece.sourceName])),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: ListTile(
              leading: const Icon(Icons.close),
              title: Text('cancel'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveInkWell extends ConsumerWidget {
  final NewsPiece piece;

  const _SaveInkWell(this.piece);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(savedNewsRepositoryProvider).savePiece(piece);
        showSnackBarMessage(context, 'saved_message'.tr());
        Navigator.pop(context);
      },
      child: ListTile(
        leading: const Icon(Icons.star_border),
        title: Text('save'.tr()),
      ),
    );
  }
}

class _RemoveInkWell extends ConsumerWidget {
  final String pieceId;

  const _RemoveInkWell(this.pieceId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(savedNewsRepositoryProvider).removePiece(pieceId);
        showSnackBarMessage(context, 'unsaved_message'.tr());
        Navigator.pop(context);
      },
      child: ListTile(
        leading: const Icon(Icons.delete_outlined),
        title: Text('remove'.tr()),
      ),
    );
  }
}
