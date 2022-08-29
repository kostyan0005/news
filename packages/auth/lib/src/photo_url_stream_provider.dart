import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

/// The provider of current user photo url stream.
final photoUrlStreamProvider = StreamProvider<String?>(
  (ref) => ref.read(authRepositoryProvider).userChangesStream.map((user) {
    for (final info in user.providerData) {
      if (info.photoURL != null) return info.photoURL;
    }
    return null;
  }),
);
