import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/pages/search_results_page.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

final searchTextProvider = StateProvider((_) => '');

class SearchTextPage extends ConsumerWidget {
  const SearchTextPage();

  static const routeName = '/search';

  void _goToSearchResults(WidgetRef ref, BuildContext context) {
    final searchText = ref.read(searchTextProvider.notifier).state;
    if (searchText.isNotEmpty) {
      Navigator.of(context).pushNamed(
        SearchResultsPage.routeName,
        arguments: SearchQuery(
          text: searchText,
          locale: ref.read(userSettingsRepositoryProvider).myLocale,
          isSubscribed: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (text) =>
                ref.read(searchTextProvider.notifier).state = text,
            onSubmitted: (_) => _goToSearchResults(ref, context),
            autofocus: true,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'search_text'.tr(),
              hintStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              hintMaxLines: 1,
              enabledBorder: InputBorder.none,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
            ),
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: () => _goToSearchResults(ref, context),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
                textStyle: const TextStyle(fontSize: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text('search'.tr()),
            ),
          ),
        ),
      ),
    );
  }
}
