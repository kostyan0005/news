// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'news_piece_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NewsPiece _$NewsPieceFromJson(Map<String, dynamic> json) {
  return _NewsPiece.fromJson(json);
}

/// @nodoc
class _$NewsPieceTearOff {
  const _$NewsPieceTearOff();

  _NewsPiece call(
      {required String id,
      required String link,
      required String title,
      required String sourceName,
      required String sourceLink,
      required DateTime pubDate,
      required bool isSaved}) {
    return _NewsPiece(
      id: id,
      link: link,
      title: title,
      sourceName: sourceName,
      sourceLink: sourceLink,
      pubDate: pubDate,
      isSaved: isSaved,
    );
  }

  NewsPiece fromJson(Map<String, Object> json) {
    return NewsPiece.fromJson(json);
  }
}

/// @nodoc
const $NewsPiece = _$NewsPieceTearOff();

/// @nodoc
mixin _$NewsPiece {
  String get id => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get sourceName => throw _privateConstructorUsedError;
  String get sourceLink => throw _privateConstructorUsedError;
  DateTime get pubDate => throw _privateConstructorUsedError;
  bool get isSaved => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewsPieceCopyWith<NewsPiece> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsPieceCopyWith<$Res> {
  factory $NewsPieceCopyWith(NewsPiece value, $Res Function(NewsPiece) then) =
      _$NewsPieceCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String link,
      String title,
      String sourceName,
      String sourceLink,
      DateTime pubDate,
      bool isSaved});
}

/// @nodoc
class _$NewsPieceCopyWithImpl<$Res> implements $NewsPieceCopyWith<$Res> {
  _$NewsPieceCopyWithImpl(this._value, this._then);

  final NewsPiece _value;
  // ignore: unused_field
  final $Res Function(NewsPiece) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? link = freezed,
    Object? title = freezed,
    Object? sourceName = freezed,
    Object? sourceLink = freezed,
    Object? pubDate = freezed,
    Object? isSaved = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sourceName: sourceName == freezed
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String,
      sourceLink: sourceLink == freezed
          ? _value.sourceLink
          : sourceLink // ignore: cast_nullable_to_non_nullable
              as String,
      pubDate: pubDate == freezed
          ? _value.pubDate
          : pubDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSaved: isSaved == freezed
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$NewsPieceCopyWith<$Res> implements $NewsPieceCopyWith<$Res> {
  factory _$NewsPieceCopyWith(
          _NewsPiece value, $Res Function(_NewsPiece) then) =
      __$NewsPieceCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String link,
      String title,
      String sourceName,
      String sourceLink,
      DateTime pubDate,
      bool isSaved});
}

/// @nodoc
class __$NewsPieceCopyWithImpl<$Res> extends _$NewsPieceCopyWithImpl<$Res>
    implements _$NewsPieceCopyWith<$Res> {
  __$NewsPieceCopyWithImpl(_NewsPiece _value, $Res Function(_NewsPiece) _then)
      : super(_value, (v) => _then(v as _NewsPiece));

  @override
  _NewsPiece get _value => super._value as _NewsPiece;

  @override
  $Res call({
    Object? id = freezed,
    Object? link = freezed,
    Object? title = freezed,
    Object? sourceName = freezed,
    Object? sourceLink = freezed,
    Object? pubDate = freezed,
    Object? isSaved = freezed,
  }) {
    return _then(_NewsPiece(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      link: link == freezed
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sourceName: sourceName == freezed
          ? _value.sourceName
          : sourceName // ignore: cast_nullable_to_non_nullable
              as String,
      sourceLink: sourceLink == freezed
          ? _value.sourceLink
          : sourceLink // ignore: cast_nullable_to_non_nullable
              as String,
      pubDate: pubDate == freezed
          ? _value.pubDate
          : pubDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSaved: isSaved == freezed
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NewsPiece implements _NewsPiece {
  const _$_NewsPiece(
      {required this.id,
      required this.link,
      required this.title,
      required this.sourceName,
      required this.sourceLink,
      required this.pubDate,
      required this.isSaved});

  factory _$_NewsPiece.fromJson(Map<String, dynamic> json) =>
      _$$_NewsPieceFromJson(json);

  @override
  final String id;
  @override
  final String link;
  @override
  final String title;
  @override
  final String sourceName;
  @override
  final String sourceLink;
  @override
  final DateTime pubDate;
  @override
  final bool isSaved;

  @override
  String toString() {
    return 'NewsPiece(id: $id, link: $link, title: $title, sourceName: $sourceName, sourceLink: $sourceLink, pubDate: $pubDate, isSaved: $isSaved)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NewsPiece &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.link, link) ||
                const DeepCollectionEquality().equals(other.link, link)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.sourceName, sourceName) ||
                const DeepCollectionEquality()
                    .equals(other.sourceName, sourceName)) &&
            (identical(other.sourceLink, sourceLink) ||
                const DeepCollectionEquality()
                    .equals(other.sourceLink, sourceLink)) &&
            (identical(other.pubDate, pubDate) ||
                const DeepCollectionEquality()
                    .equals(other.pubDate, pubDate)) &&
            (identical(other.isSaved, isSaved) ||
                const DeepCollectionEquality().equals(other.isSaved, isSaved)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(link) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(sourceName) ^
      const DeepCollectionEquality().hash(sourceLink) ^
      const DeepCollectionEquality().hash(pubDate) ^
      const DeepCollectionEquality().hash(isSaved);

  @JsonKey(ignore: true)
  @override
  _$NewsPieceCopyWith<_NewsPiece> get copyWith =>
      __$NewsPieceCopyWithImpl<_NewsPiece>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NewsPieceToJson(this);
  }
}

abstract class _NewsPiece implements NewsPiece {
  const factory _NewsPiece(
      {required String id,
      required String link,
      required String title,
      required String sourceName,
      required String sourceLink,
      required DateTime pubDate,
      required bool isSaved}) = _$_NewsPiece;

  factory _NewsPiece.fromJson(Map<String, dynamic> json) =
      _$_NewsPiece.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get link => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  String get sourceName => throw _privateConstructorUsedError;
  @override
  String get sourceLink => throw _privateConstructorUsedError;
  @override
  DateTime get pubDate => throw _privateConstructorUsedError;
  @override
  bool get isSaved => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NewsPieceCopyWith<_NewsPiece> get copyWith =>
      throw _privateConstructorUsedError;
}
