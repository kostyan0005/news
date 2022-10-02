import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';

/// The provider of the [UserSettingsRepository] instance.
final userSettingsRepositoryProvider = Provider((ref) => UserSettingsRepository(
    ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

/// The repository for working with user settings and getting their stream.
class UserSettingsRepository {
  final DocumentReference<Map<String, dynamic>> _mySettingsRef;
  UserSettings? mySettings;
  String get myLocale => mySettings?.locale ?? 'en_US';

  UserSettingsRepository(String myId, FirebaseFirestore firestore)
      : _mySettingsRef = firestore.collection('users').doc(myId);

  /// Gets one of the available locales based on [isRu] indicator.
  static String getSupportedLocale(bool isRu) => isRu ? 'ru_UA' : 'en_US';

  /// Gets the stream of current user's settings changes.
  Stream<UserSettings> getSettingsStream() {
    final initialStream = _mySettingsRef.snapshots().handleError((e) =>
        // Do not log permission-denied error.
        e is FirebaseException && e.code == 'permission-denied'
            ? null
            : Logger().e(e));

    final filteredStream = initialStream.where((snap) {
      if (!snap.exists) {
        final isSystemRu = Intl.systemLocale.contains(RegExp(r'(ru|ua)_UA'));
        setInitialSettings(getSupportedLocale(isSystemRu));
      }
      return snap.exists;
    });

    return filteredStream
        .map((snap) => mySettings = UserSettings.fromJson(snap.data()!));
  }

  /// Sets the initial user settings if they are not present yet.
  Future<void> setInitialSettings(String initialLocale) {
    return _mySettingsRef.set(UserSettings(locale: initialLocale).toJson());
  }

  /// Updates the news locale of the current user.
  Future<void> updateLocale(String newLocale) {
    return _mySettingsRef.update({'locale': newLocale});
  }
}
