// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_query_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SearchQuery _$_$_SearchQueryFromJson(Map<String, dynamic> json) {
  return _$_SearchQuery(
    text: json['text'] as String,
    languageCode: json['languageCode'] as String,
    countryCode: json['countryCode'] as String,
    isSubscribed: json['isSubscribed'] as bool,
  );
}

Map<String, dynamic> _$_$_SearchQueryToJson(_$_SearchQuery instance) =>
    <String, dynamic>{
      'text': instance.text,
      'languageCode': instance.languageCode,
      'countryCode': instance.countryCode,
      'isSubscribed': instance.isSubscribed,
    };
