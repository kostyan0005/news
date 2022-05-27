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

List<Map<String, dynamic>> generateTestJsonList(bool isSaved,
    {int length = 10}) {
  return List.generate(length, (index) => generateTestJson(index, isSaved));
}

Map<String, dynamic> generateTestJson(int index, bool isSaved) {
  return {
    'id': '$index',
    'link': '',
    'title': '',
    'sourceName': '',
    'sourceLink': '',
    'pubDate': DateTime(2000).toIso8601String(),
    'isSaved': isSaved,
    if (isSaved) 'dateSaved': DateTime(2000, 1, index + 1).toIso8601String(),
  };
}
