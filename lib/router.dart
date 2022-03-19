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
    ),
    GoRoute(
      name: 'piece',
      path: '/piece/:id',
      // todo: on sharing, switch from new piece original link to in-app link
      // todo: additionally process sharedFrom parameter when link is shared
      builder: (_, state) => NewsPiecePage(
        id: state.params['id']!,
        fromSaved: false,
      ),
    ),
    GoRoute(
      name: 'saved_piece',
      path: '/saved/:id',
      builder: (_, state) => NewsPiecePage(
        id: state.params['id']!,
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
    // todo: try updating 'text' query param on each keystroke
    // todo: if not possible, then just enable putting param content into text field
    GoRoute(
      name: 'search_text',
      path: '/search',
      builder: (_, state) => const SearchTextPage(),
    ),
    GoRoute(
      name: 'search_results',
      path: '/search/:text',
      builder: (_, state) => SearchResultsPage(
        queryText: state.params['text']!,
        queryLocale: state.queryParams['locale'],
        isSubscribed: state.queryParams['subscribed'] == 'true',
      ),
    ),
    GoRoute(
      name: 'locale_selection',
      path: '/locale',
      builder: (_, __) => const LocaleSelectionPage(),
    ),
  ],
);
