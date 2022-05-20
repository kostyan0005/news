import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';

final userSettingsRepositoryProvider = Provider((ref) => UserSettingsRepository(
    ref.watch(uidNotifierProvider), ref.read(firestoreProvider)));

// todo: test
class UserSettingsRepository {
  final DocumentReference<Map<String, dynamic>> _mySettingsRef;
  UserSettings? mySettings;
  String get myLocale => mySettings?.locale ?? 'en_US';

  UserSettingsRepository(String myId, FirebaseFirestore firestore)
      : _mySettingsRef = firestore.collection('users').doc(myId);

  Stream<UserSettings> getSettingsStream() async* {
    final snapshotStream = _mySettingsRef.snapshots().handleError((e) =>
        // do not log permission-denied error
        e is FirebaseException && e.code == 'permission-denied'
            ? null
            : Logger().e(e));

    await for (final settingsSnap in snapshotStream) {
      if (settingsSnap.exists) {
        final newSettings = UserSettings.fromJson(settingsSnap.data()!);
        if (newSettings != mySettings) {
          mySettings = newSettings;
          yield newSettings;
        }
      } else {
        // determine initial locale
        final isRu = Intl.systemLocale.contains(RegExp(r'(ru|ua)_UA'));
        mySettings = UserSettings(locale: isRu ? 'ru_UA' : 'en_US');
        yield mySettings!;

        // add settings with this locale to db
        _mySettingsRef.set(mySettings!.toJson());
      }
    }
  }

  Future<void> updateLocale(String newLocale) async {
    await _mySettingsRef.update({'locale': newLocale});
  }
}
