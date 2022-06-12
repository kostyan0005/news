import 'package:news/modules/news/models/news_piece_model.dart';

List<NewsPiece> generateTestPieceListFromTitle(String title,
    {int length = 20}) {
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

List<Map<String, dynamic>> generateTestPieceJsonList(bool isSaved,
    [int length = 10]) {
  return List.generate(
      length, (index) => generateTestPieceJson(index, isSaved));
}

Map<String, dynamic> generateTestPieceJson(int index, bool isSaved) {
  return {
    'id': '$index',
    'link': '',
    'title': '$index',
    'sourceName': '',
    'sourceLink': '',
    'pubDate': DateTime(2000).toIso8601String(),
    'isSaved': isSaved,
    if (isSaved) 'dateSaved': DateTime(2000, 1, index + 1).toIso8601String(),
  };
}

List<Map<String, dynamic>> generateTestSubscriptionJsonList([int length = 10]) {
  return List.generate(length, (index) => generateTestSubscriptionJson(index));
}

Map<String, dynamic> generateTestSubscriptionJson(int index) {
  return {
    'text': '$index',
    'locale': 'en_US',
    'isSubscribed': true,
    'subscriptionDate': DateTime(2000, 1, index + 1).toIso8601String(),
  };
}
