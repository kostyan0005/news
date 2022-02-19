import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final uidNotifierProvider = StateNotifierProvider<UidNotifier, String>(
    (_) => UidNotifier(AuthRepository.instance));

class UidNotifier extends StateNotifier<String> {
  UidNotifier(AuthRepository repo) : super(repo.myId) {
    repo.uidStream.listen((uid) {
      if (state != uid) {
        state = uid;
      }
    });
  }
}
