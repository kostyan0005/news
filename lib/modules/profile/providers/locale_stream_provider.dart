import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

final localeStreamProvider = StreamProvider<String>((ref) => ref
    .watch(userSettingsRepositoryProvider)
    .getSettingsStream()
    .map((settings) => settings.locale));
