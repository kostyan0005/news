import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'core/home_page.dart';
import 'modules/news/pages/all.dart';
import 'modules/profile/pages/locale_selection_page.dart';

GoRouter getRouter({
  Widget? initialWidget,
  String initialLocation = '/',
  int initialTabIndex = 0,
}) {
  return GoRouter(
    initialLocation: initialWidget != null ? '/widget' : initialLocation,
    urlPathStrategy: UrlPathStrategy.path,
    restorationScopeId: 'router',
    routes: [
      // Added for testing purposes.
      if (initialWidget != null)
        GoRoute(
          path: '/widget',
          builder: (_, __) => initialWidget,
        ),
      GoRoute(
        name: 'home',
        path: '/',
        builder: (_, __) => HomePage(
          initialTabIndex: initialTabIndex,
        ),
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
                  isSubscribed: false,
                ),
              ),
            ],
          ),
          GoRoute(
            name: 'topic',
            path: 'topic/:text',
            builder: (_, state) => SearchResultsPage(
              queryText: state.params['text']!,
              queryLocale: state.queryParams['locale'],
              isSubscribed: state.queryParams['subscribed'] == 'true',
            ),
          ),
          GoRoute(
            name: 'piece',
            path: 'piece/:id',
            builder: (_, state) => NewsPiecePage(
              pieceId: state.params['id']!,
              fromSaved: false,
              sharedFrom: state.queryParams['from'],
            ),
          ),
          GoRoute(
            name: 'saved_piece',
            path: 'saved/:id',
            builder: (_, state) => NewsPiecePage(
              pieceId: state.params['id']!,
              fromSaved: true,
            ),
          ),
          GoRoute(
            name: 'source',
            path: 'source',
            builder: (_, state) => SourcePage(
              name: state.queryParams['name'],
              link: state.queryParams['link'],
            ),
          ),
          GoRoute(
            name: 'locale_selection',
            path: 'locale',
            builder: (_, __) => const LocaleSelectionPage(),
          ),
        ],
      ),
    ],
  );
}
