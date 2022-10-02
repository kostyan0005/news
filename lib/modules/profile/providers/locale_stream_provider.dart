import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

// todo
final localeStreamProvider = StreamProvider<String>((ref) => ref
    .watch(userSettingsRepositoryProvider)
    .getSettingsStream()
    .map((settings) => settings.locale));
