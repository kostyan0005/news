// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_query_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SearchQuery _$$_SearchQueryFromJson(Map<String, dynamic> json) =>
    _$_SearchQuery(
      text: json['text'] as String,
      locale: json['locale'] as String,
      isSubscribed: json['isSubscribed'] as bool,
    );

Map<String, dynamic> _$$_SearchQueryToJson(_$_SearchQuery instance) =>
    <String, dynamic>{
      'text': instance.text,
      'locale': instance.locale,
      'isSubscribed': instance.isSubscribed,
    };
