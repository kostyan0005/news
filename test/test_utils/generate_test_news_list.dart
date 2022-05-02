import 'package:news/modules/news/models/news_piece_model.dart';

List<NewsPiece> generateTestNewsListFromTitle(String title, {int length = 20}) {
  return List.generate(
    length,
    (index) => NewsPiece(
      title: '$title $index',
      id: '',
      link: '',
      sourceName: '',
      sourceLink: '',
      pubDate: DateTime.now(),
      isSaved: false,
    ),
  );
}
