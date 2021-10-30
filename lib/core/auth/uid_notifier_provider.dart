import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/auth/auth_repository.dart';

final uidNotifierProvider = StateNotifierProvider<UidNotifier, String>(
    (ref) => UidNotifier(ref.read(authRepositoryProvider)));

class UidNotifier extends StateNotifier<String> {
  UidNotifier(AuthRepository repo) : super(repo.myId) {
    repo.uidStream.listen((uid) => state != uid ? state = uid : null);
  }
}
