import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/auth/auth_repository.dart';

final anonymousSingInProvider = FutureProvider((ref) async =>
    ref.read(authRepositoryProvider).signInAnonymouslyIfNeeded());
