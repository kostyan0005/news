import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/pages/source_page.dart';
import 'package:news/modules/news/providers/piece_saved_status_provider.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:share_plus/share_plus.dart';

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
              builder: (_, watch, __) =>
                  watch(pieceSavedStatusProvider(piece.id)).maybeWhen(
                data: (isSaved) =>
                    isSaved ? _RemoveInkWell(piece.id) : _SaveInkWell(piece),
                orElse: () => _SaveInkWell(piece),
              ),
            ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Share.share(piece.title + ': ' + piece.link);
            },
            child: ListTile(
              leading: Icon(Icons.ios_share),
              title: Text('Share'),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context)
                .popAndPushNamed(SourcePage.routeName, arguments: piece),
            child: ListTile(
              leading: Icon(Icons.open_in_new),
              title: Text('Go to page "${piece.sourceName}"'),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: ListTile(
              leading: Icon(Icons.close),
              title: Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveInkWell extends StatelessWidget {
  final NewsPiece piece;

  const _SaveInkWell(this.piece);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read(savedNewsRepositoryProvider).savePiece(piece);
        showQuickSnackBarMessage(context, 'Added to saved news');
        Navigator.pop(context);
      },
      child: ListTile(
        leading: Icon(Icons.star_border),
        title: Text('Save'),
      ),
    );
  }
}

class _RemoveInkWell extends StatelessWidget {
  final String pieceId;

  const _RemoveInkWell(this.pieceId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read(savedNewsRepositoryProvider).removePiece(pieceId);
        showQuickSnackBarMessage(context, 'Removed from saved news');
        Navigator.pop(context);
      },
      child: ListTile(
        leading: Icon(Icons.delete_outlined),
        title: Text('Remove'),
      ),
    );
  }
}
