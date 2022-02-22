import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';

final savedNewsStreamProvider = StreamProvider<List<NewsPiece>>(
    (ref) => ref.watch(savedNewsRepositoryProvider).getSavedNewsStream());
