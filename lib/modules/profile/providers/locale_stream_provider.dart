import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

/// The provider of the stream of changes of current user's selected locale.
final localeStreamProvider = StreamProvider<String>((ref) => ref
    .watch(userSettingsRepositoryProvider)
    .getSettingsStream()
    .map((settings) => settings.locale));
