// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_piece_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NewsPiece _$$_NewsPieceFromJson(Map<String, dynamic> json) => _$_NewsPiece(
      id: json['id'] as String,
      link: json['link'] as String,
      title: json['title'] as String,
      sourceName: json['sourceName'] as String,
      sourceLink: json['sourceLink'] as String,
      pubDate: DateTime.parse(json['pubDate'] as String),
      isSaved: json['isSaved'] as bool,
    );

Map<String, dynamic> _$$_NewsPieceToJson(_$_NewsPiece instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'title': instance.title,
      'sourceName': instance.sourceName,
      'sourceLink': instance.sourceLink,
      'pubDate': instance.pubDate.toIso8601String(),
      'isSaved': instance.isSaved,
    };
