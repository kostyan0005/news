// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'search_query_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SearchQuery _$SearchQueryFromJson(Map<String, dynamic> json) {
  return _SearchQuery.fromJson(json);
}

/// @nodoc
class _$SearchQueryTearOff {
  const _$SearchQueryTearOff();

  _SearchQuery call(
      {required String text,
      required String languageCode,
      required String countryCode,
      required bool isSubscribed}) {
    return _SearchQuery(
      text: text,
      languageCode: languageCode,
      countryCode: countryCode,
      isSubscribed: isSubscribed,
    );
  }

  SearchQuery fromJson(Map<String, Object> json) {
    return SearchQuery.fromJson(json);
  }
}

/// @nodoc
const $SearchQuery = _$SearchQueryTearOff();

/// @nodoc
mixin _$SearchQuery {
  String get text => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  bool get isSubscribed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchQueryCopyWith<SearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchQueryCopyWith<$Res> {
  factory $SearchQueryCopyWith(
          SearchQuery value, $Res Function(SearchQuery) then) =
      _$SearchQueryCopyWithImpl<$Res>;
  $Res call(
      {String text,
      String languageCode,
      String countryCode,
      bool isSubscribed});
}

/// @nodoc
class _$SearchQueryCopyWithImpl<$Res> implements $SearchQueryCopyWith<$Res> {
  _$SearchQueryCopyWithImpl(this._value, this._then);

  final SearchQuery _value;
  // ignore: unused_field
  final $Res Function(SearchQuery) _then;

  @override
  $Res call({
    Object? text = freezed,
    Object? languageCode = freezed,
    Object? countryCode = freezed,
    Object? isSubscribed = freezed,
  }) {
    return _then(_value.copyWith(
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: languageCode == freezed
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: countryCode == freezed
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      isSubscribed: isSubscribed == freezed
          ? _value.isSubscribed
          : isSubscribed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$SearchQueryCopyWith<$Res>
    implements $SearchQueryCopyWith<$Res> {
  factory _$SearchQueryCopyWith(
          _SearchQuery value, $Res Function(_SearchQuery) then) =
      __$SearchQueryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String text,
      String languageCode,
      String countryCode,
      bool isSubscribed});
}

/// @nodoc
class __$SearchQueryCopyWithImpl<$Res> extends _$SearchQueryCopyWithImpl<$Res>
    implements _$SearchQueryCopyWith<$Res> {
  __$SearchQueryCopyWithImpl(
      _SearchQuery _value, $Res Function(_SearchQuery) _then)
      : super(_value, (v) => _then(v as _SearchQuery));

  @override
  _SearchQuery get _value => super._value as _SearchQuery;

  @override
  $Res call({
    Object? text = freezed,
    Object? languageCode = freezed,
    Object? countryCode = freezed,
    Object? isSubscribed = freezed,
  }) {
    return _then(_SearchQuery(
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: languageCode == freezed
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: countryCode == freezed
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      isSubscribed: isSubscribed == freezed
          ? _value.isSubscribed
          : isSubscribed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SearchQuery implements _SearchQuery {
  const _$_SearchQuery(
      {required this.text,
      required this.languageCode,
      required this.countryCode,
      required this.isSubscribed});

  factory _$_SearchQuery.fromJson(Map<String, dynamic> json) =>
      _$_$_SearchQueryFromJson(json);

  @override
  final String text;
  @override
  final String languageCode;
  @override
  final String countryCode;
  @override
  final bool isSubscribed;

  @override
  String toString() {
    return 'SearchQuery(text: $text, languageCode: $languageCode, countryCode: $countryCode, isSubscribed: $isSubscribed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SearchQuery &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.languageCode, languageCode) ||
                const DeepCollectionEquality()
                    .equals(other.languageCode, languageCode)) &&
            (identical(other.countryCode, countryCode) ||
                const DeepCollectionEquality()
                    .equals(other.countryCode, countryCode)) &&
            (identical(other.isSubscribed, isSubscribed) ||
                const DeepCollectionEquality()
                    .equals(other.isSubscribed, isSubscribed)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(languageCode) ^
      const DeepCollectionEquality().hash(countryCode) ^
      const DeepCollectionEquality().hash(isSubscribed);

  @JsonKey(ignore: true)
  @override
  _$SearchQueryCopyWith<_SearchQuery> get copyWith =>
      __$SearchQueryCopyWithImpl<_SearchQuery>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SearchQueryToJson(this);
  }
}

abstract class _SearchQuery implements SearchQuery {
  const factory _SearchQuery(
      {required String text,
      required String languageCode,
      required String countryCode,
      required bool isSubscribed}) = _$_SearchQuery;

  factory _SearchQuery.fromJson(Map<String, dynamic> json) =
      _$_SearchQuery.fromJson;

  @override
  String get text => throw _privateConstructorUsedError;
  @override
  String get languageCode => throw _privateConstructorUsedError;
  @override
  String get countryCode => throw _privateConstructorUsedError;
  @override
  bool get isSubscribed => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SearchQueryCopyWith<_SearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}
