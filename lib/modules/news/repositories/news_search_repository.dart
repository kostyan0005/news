import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/utils/example_xml.dart';
import 'package:xml/xml.dart';

/// The provider of [NewsSearchRepository] instance.
final newsSearchRepositoryProvider = Provider((_) => NewsSearchRepository());

/// The repository responsible for getting news piece from RSS URLs and parsing them.
class NewsSearchRepository {
  final _client = http.Client();

  /// Gets the news pieces from the particular [url].
  ///
  /// Throws [HttpException] in case the status code of the response is not 200.
  /// On the web, getting the pieces does not work because of CORS policy, so
  /// return the example news pieces instead.
  Future<List<NewsPiece>> getNewsFromRssUrl(String url) async {
    if (kIsWeb) {
      // Fetching news on the web does not work, so return the example pieces.
      return parseNewsFromXml(getExampleXml());
    }

    final uri = Uri.parse(url);
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      final message = 'Status code: ${response.statusCode}.\n'
          'Reason: ${response.reasonPhrase}.';
      throw HttpException(message, uri: uri);
    }

    return parseNewsFromXml(response.body);
  }

  /// Parses the [rawXml] string and returns the parsed news pieces.
  List<NewsPiece> parseNewsFromXml(String rawXml) {
    return XmlDocument.parse(rawXml)
        .findAllElements('item')
        .map((e) => NewsPiece.fromXml(e))
        .where((p) => !p.sourceLink.endsWith('.ru'))
        .toList();
  }
}
