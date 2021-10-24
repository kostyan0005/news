import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/auth/auth_repository.dart';

final photoUrlStreamProvider = StreamProvider<String?>(
  (ref) => ref.read(authRepositoryProvider).userChangesStream.map((user) {
    if (user == null || user.isAnonymous) {
      return null;
    } else {
      for (final info in user.providerData) {
        if (info.photoURL != null) return info.photoURL;
      }
      return null;
    }
  }),
);
