import 'package:news/core/home/home_page.dart';
import 'package:news/modules/news/pages/all.dart';

final routes = {
  HomePage.routeName: (_) => HomePage(),
  NewsPiecePage.routeName: (_) => NewsPiecePage(),
  SourcePage.routeName: (_) => SourcePage(),
  SearchTextPage.routeName: (_) => SearchTextPage(),
  SearchQueryPage.routeName: (_) => SearchQueryPage(),
};
