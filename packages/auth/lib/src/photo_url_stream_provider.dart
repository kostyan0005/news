import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final photoUrlStreamProvider = StreamProvider<String?>(
  (_) => AuthRepository.instance.userChangesStream.map((user) {
    for (final info in user.providerData) {
      if (info.photoURL != null) return info.photoURL;
    }
    return null;
  }),
);
