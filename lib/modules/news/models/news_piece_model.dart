import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

part 'news_piece_model.freezed.dart';
part 'news_piece_model.g.dart';

@freezed
class NewsPiece with _$NewsPiece {
  const factory NewsPiece({
    required String id,
    required String link,
    required String title,
    required String sourceName,
    required String sourceLink,
    required DateTime pubDate,
    required bool isSaved,
  }) = _NewsPiece;

  factory NewsPiece.fromJson(Map<String, dynamic> json) =>
      _$NewsPieceFromJson(json);

  factory NewsPiece.fromXml(XmlElement item) {
    var guid = item.findElements('guid').first.text;
    if (guid.length > 10) guid = guid.substring(0, 10);
    final titleWithSource = item.findElements('title').first.text;
    final source = item.findElements('source').first;
    final sourceName = source.text;
    final title = titleWithSource.replaceAll(' - $sourceName', '');
    final pubDate = DateFormat('EEE, dd MMM yyyy hh:mm:ss', 'en')
        .parse(item.findElements('pubDate').first.text, true);

    return NewsPiece(
      id: '$guid${pubDate.millisecondsSinceEpoch ~/ 1000}', // has 20 chars
      link: item.findElements('link').first.text,
      title: title,
      sourceName: sourceName,
      sourceLink: source.getAttribute('url')!,
      pubDate: pubDate,
      isSaved: false,
    );
  }
}
