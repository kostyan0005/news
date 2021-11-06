import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:news/core/auth/uid_notifier_provider.dart';
import 'package:news/modules/profile/models/user_settings.dart';

final userSettingsRepositoryProvider =
    Provider((ref) => UserSettingsRepository(ref.watch(uidNotifierProvider)));

class UserSettingsRepository {
  final DocumentReference<Map<String, dynamic>> _mySettingsRef;
  UserSettings? mySettings;
  String get myLocale => mySettings?.locale ?? 'en_US';

  UserSettingsRepository(String myId)
      : _mySettingsRef =
            FirebaseFirestore.instance.collection('users').doc(myId);

  Stream<UserSettings> getSettingsStream() async* {
    await for (final settingsDoc in _mySettingsRef.snapshots()) {
      if (settingsDoc.exists) {
        final newSettings = UserSettings.fromJson(settingsDoc.data()!);
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
