import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';

// todo: handle the case where user is changed
final savedNewsStreamProvider = StreamProvider<List<NewsPiece>>(
    (ref) => ref.read(savedNewsRepositoryProvider).getSavedNewsStream());
