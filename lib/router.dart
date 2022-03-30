import 'package:go_router/go_router.dart';

import 'core/home/home_page.dart';
import 'modules/news/pages/all.dart';
import 'modules/profile/pages/locale_selection_page.dart';

final router = GoRouter(
  urlPathStrategy: UrlPathStrategy.path,
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (_, __) => const HomePage(),
      routes: [
        GoRoute(
          name: 'search_text',
          path: 'search',
          builder: (_, state) => SearchTextPage(
            key: state.pageKey,
            text: state.queryParams['text'] ?? '',
          ),
          routes: [
            GoRoute(
              name: 'search_results',
              path: ':text',
              builder: (_, state) => SearchResultsPage(
                queryText: state.params['text']!,
                queryLocale: state.queryParams['locale'],
                isSubscribed: state.queryParams['subscribed'] == 'true',
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'piece',
      path: '/piece/:id',
      builder: (_, state) => NewsPiecePage(
        pieceId: state.params['id']!,
        fromSaved: false,
        sharedFrom: state.queryParams['from'],
      ),
    ),
    GoRoute(
      name: 'saved_piece',
      path: '/saved/:id',
      builder: (_, state) => NewsPiecePage(
        pieceId: state.params['id']!,
        fromSaved: true,
      ),
    ),
    GoRoute(
      name: 'source',
      path: '/source',
      builder: (_, state) => SourcePage(
        name: state.queryParams['name'],
        link: state.queryParams['link'],
      ),
    ),
    GoRoute(
      name: 'locale_selection',
      path: '/locale',
      builder: (_, __) => const LocaleSelectionPage(),
    ),
  ],
);
