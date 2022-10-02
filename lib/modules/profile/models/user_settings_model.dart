import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings_model.freezed.dart';
part 'user_settings_model.g.dart';

/// The model of possible user settings.
///
/// For now, the only available setting is the news locale.
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({required String locale}) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
