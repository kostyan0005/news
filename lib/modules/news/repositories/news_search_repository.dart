import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:xml/xml.dart';

final newsSearchRepositoryProvider = Provider((_) => NewsSearchRepository());

class NewsSearchRepository {
  Future<List<NewsPiece>> getNewsFromRssUrl(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      final message = 'Status code: ${response.statusCode}.\n'
          'Reason: ${response.reasonPhrase}.';
      Logger().e(message);
      throw HttpException(message, uri: uri);
    }

    final elements = XmlDocument.parse(response.body).findAllElements('item');
    return elements
        .map((e) => NewsPiece.fromXml(e))
        .where((p) => !p.sourceLink.endsWith('.ru'))
        .toList();
  }
}
