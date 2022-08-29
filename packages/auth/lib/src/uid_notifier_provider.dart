import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

/// The state notifier provider containing current user uid updates.
///
/// The [UidNotifier] class is used to notify about state updates.
final uidNotifierProvider = StateNotifierProvider<UidNotifier, String>(
    (ref) => UidNotifier(ref.read(authRepositoryProvider)));

/// The notifier of current user uid updates.
class UidNotifier extends StateNotifier<String> {
  UidNotifier(AuthRepository repo) : super(repo.myId) {
    repo.uidStream.listen((uid) {
      if (mounted && state != uid) state = uid;
    });
  }
}
