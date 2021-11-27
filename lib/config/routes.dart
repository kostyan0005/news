import 'package:news/core/home/home_page.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/profile/pages/locale_selection_page.dart';

final routes = {
  HomePage.routeName: (_) => const HomePage(),
  NewsPiecePage.routeName: (_) => const NewsPiecePage(),
  SourcePage.routeName: (_) => const SourcePage(),
  SearchTextPage.routeName: (_) => const SearchTextPage(),
  SearchQueryPage.routeName: (_) => const SearchQueryPage(),
  LocaleSelectionPage.routeName: (_) => const LocaleSelectionPage(),
};
