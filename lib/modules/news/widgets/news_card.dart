import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/history_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'options_sheet.dart';

class NewsCard extends ConsumerStatefulWidget {
  final NewsPiece piece;

  const NewsCard(this.piece);

  @override
  ConsumerState<NewsCard> createState() => _NewsItemState();
}

class _NewsItemState extends ConsumerState<NewsCard> {
  bool _isSelecting = false;

  void _goToNewsPiecePage() {
    ref.read(historyRepositoryProvider).addPieceToHistory(widget.piece);

    context.pushNamed(
      widget.piece.isSaved ? 'saved_piece' : 'piece',
      params: {'id': widget.piece.id},
    );
  }

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (_) => OptionsSheet(widget.piece),
    );
  }

  void _onSelectableTextTap() {
    if (!_isSelecting) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_isSelecting) {
          _goToNewsPiecePage();
        }
      });
    }
  }

  void _onSelectionChanged(TextSelection selection, _) {
    if (selection.isCollapsed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isSelecting = false;
        FocusScope.of(context).unfocus();
      });
    } else if (!_isSelecting) {
      _isSelecting = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceDotTime =
        '${widget.piece.sourceName} · ${timeago.format(widget.piece.pubDate)}';

    return Card(
      child: InkWell(
        onTap: _goToNewsPiecePage,
        onLongPress: _showOptionsSheet,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 16),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            mouseCursor: MouseCursor.defer,
            title: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: !kIsWeb
                  ? Text(widget.piece.title)
                  : SelectableText(
                      widget.piece.title,
                      onTap: _onSelectableTextTap,
                      onSelectionChanged: _onSelectionChanged,
                    ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: !kIsWeb
                          ? Text(
                              sourceDotTime,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : SelectableText(
                              sourceDotTime,
                              style: Theme.of(context).textTheme.bodySmall,
                              onTap: _onSelectableTextTap,
                              onSelectionChanged: _onSelectionChanged,
                            ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showOptionsSheet,
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.grey,
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    maxHeight: 30,
                    maxWidth: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
