import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

import '../../../test_utils/all.dart';

void main() async {
  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;
  late UserSettingsRepository sut;

  group('UserSettingsRepository', () {
    setUp(() async {
      firestore = FakeFirebaseFirestore();
      container = ProviderContainer(
        overrides: [
          firestoreProvider.overrideWithValue(firestore),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
      );

      sut = container.read(userSettingsRepositoryProvider);
    });

    Future<UserSettings?> getMySettings() {
      return firestore.collection('users').doc(testUserId).get().then(
          (snap) => snap.exists ? UserSettings.fromJson(snap.data()!) : null);
    }

    test('initial state is correct', () async {
      expect(await getMySettings(), null);
      expect(sut.mySettings, null);
      expect(sut.myLocale, 'en_US');
    });

    test('setInitialSettings', () async {
      await sut.setInitialSettings('en_US');
      expect(await getMySettings(), const UserSettings(locale: 'en_US'));
    });

    test('updateLocale', () async {
      await sut.setInitialSettings('en_US');
      await sut.updateLocale('ru_UA');
      expect(await getMySettings(), const UserSettings(locale: 'ru_UA'));
    });

    test('getSettingsStream', () async {
      final initialSettings = await sut.getSettingsStream().first;

      expect(initialSettings, const UserSettings(locale: 'en_US'));
      expect(await getMySettings(), initialSettings);
      expect(sut.mySettings, initialSettings);
      expect(sut.myLocale, initialSettings.locale);

      await sut.updateLocale('ru_UA');
      final updatedSettings = await sut.getSettingsStream().first;

      expect(updatedSettings, const UserSettings(locale: 'ru_UA'));
      expect(sut.mySettings, updatedSettings);
      expect(sut.myLocale, updatedSettings.locale);
    });
  });
}
