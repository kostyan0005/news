import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';

// todo: test
final pieceSavedStatusProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, pieceId) =>
        ref.read(savedNewsRepositoryProvider).isPieceSaved(pieceId));
