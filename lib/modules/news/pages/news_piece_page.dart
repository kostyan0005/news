import 'package:flutter/material.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/widgets/link_view.dart';
import 'package:news/modules/news/widgets/options_sheet.dart';

class NewsPiecePage extends StatelessWidget {
  const NewsPiecePage();

  static const routeName = '/newsPiecePage';

  @override
  Widget build(BuildContext context) {
    final piece = ModalRoute.of(context)!.settings.arguments as NewsPiece;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
                context: context, builder: (_) => OptionsSheet(piece)),
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: LinkView(piece.link),
    );
  }
}
