import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final anonymousSingInProvider = FutureProvider((ref) async =>
    ref.read(authRepositoryProvider).signInAnonymouslyIfNeeded());
