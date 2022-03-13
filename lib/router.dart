import 'package:go_router/go_router.dart';

import 'core/home/home_page.dart';
import 'modules/news/pages/all.dart';
import 'modules/profile/pages/locale_selection_page.dart';

final router = GoRouter(
  urlPathStrategy: UrlPathStrategy.path,
  routes: [
    GoRoute(
      path: HomePage.routeName,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      name: 'piece',
      path: '/piece/:id',
      builder: (_, state) => NewsPiecePage(
        id: state.params['id']!,
        fromSaved: false,
      ),
    ),
    GoRoute(
      path: SourcePage.routeName,
      builder: (_, __) => const SourcePage(),
    ),
    GoRoute(
      path: SearchTextPage.routeName,
      builder: (_, __) => const SearchTextPage(),
    ),
    GoRoute(
      path: SearchResultsPage.routeName,
      builder: (_, __) => const SearchResultsPage(),
    ),
    GoRoute(
      path: LocaleSelectionPage.routeName,
      builder: (_, __) => const LocaleSelectionPage(),
    ),
  ],
);
