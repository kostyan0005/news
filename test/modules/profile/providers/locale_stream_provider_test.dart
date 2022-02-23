import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';
import 'package:news/modules/profile/providers/locale_stream_provider.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

class MockUserSettingsRepository extends Mock
    implements UserSettingsRepository {}

void main() {
  test('locale stream provider states are updated properly', () async {
    final repository = MockUserSettingsRepository();
    final container = ProviderContainer(
      overrides: [userSettingsRepositoryProvider.overrideWithValue(repository)],
    );

    when(() => repository.getSettingsStream()).thenAnswer((_) async* {
      await Future.delayed(const Duration(milliseconds: 100));
      yield const UserSettings(locale: 'en_US');

      await Future.delayed(const Duration(milliseconds: 100));
      yield const UserSettings(locale: 'ru_UA');
    });

    expect(
      container.read(localeStreamProvider),
      const AsyncValue<String>.loading(),
    );

    await Future.delayed(const Duration(milliseconds: 110));
    expect(container.read(localeStreamProvider).value, 'en_US');

    await Future.delayed(const Duration(milliseconds: 110));
    expect(container.read(localeStreamProvider).value, 'ru_UA');
  });
}
