import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';

final userSettingsRepositoryProvider = Provider((ref) => UserSettingsRepository(
    ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

class UserSettingsRepository {
  final DocumentReference<Map<String, dynamic>> _mySettingsRef;
  UserSettings? mySettings;
  String get myLocale => mySettings?.locale ?? 'en_US';

  UserSettingsRepository(String myId, FirebaseFirestore firestore)
      : _mySettingsRef = firestore.collection('users').doc(myId);

  static String getSupportedLocale(bool isRu) => isRu ? 'ru_UA' : 'en_US';

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

  Future<void> setInitialSettings(String initialLocale) {
    return _mySettingsRef.set(UserSettings(locale: initialLocale).toJson());
  }

  Future<void> updateLocale(String newLocale) {
    return _mySettingsRef.update({'locale': newLocale});
  }
}
