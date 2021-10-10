import 'package:flutter/material.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/widgets/link_view.dart';
import 'package:share_plus/share_plus.dart';

class SourcePage extends StatelessWidget {
  const SourcePage();

  static const routeName = '/sourcePage';

  @override
  Widget build(BuildContext context) {
    final piece = ModalRoute.of(context)!.settings.arguments as NewsPiece;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            piece.sourceName,
            style: TextStyle(fontSize: 18),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.star_border),
          ),
          IconButton(
            onPressed: () =>
                Share.share(piece.sourceName + '\n' + piece.sourceLink),
            icon: Icon(Icons.ios_share),
          ),
        ],
      ),
      body: LinkView(piece.sourceLink),
    );
  }
}
