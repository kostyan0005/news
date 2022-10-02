import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news/utils/snackbar_utils.dart';

import 'search_results_page.dart';

/// The page on which the search query [text] is entered.
///
/// State restoration is implemented for this page.
class SearchTextPage extends StatefulWidget {
  final String text;

  const SearchTextPage({
    required ValueKey<String> key,
    required this.text,
  }) : super(key: key);

  @override
  State<SearchTextPage> createState() => _SearchTextPageState();
}

class _SearchTextPageState extends State<SearchTextPage> with RestorationMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _text = RestorableString('');
  final _baseOffset = RestorableInt(0);

  @override
  void initState() {
    super.initState();
    // autofocus is not working in case of restoration from search results page
    _focusNode.requestFocus();
  }

  @override
  String get restorationId => 'SearchTextPage';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_text, 'text');
    registerForRestoration(_baseOffset, 'baseOffset');

    if (initialRestore) {
      if (_text.value.isNotEmpty) {
        _controller.text = _text.value;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _baseOffset.value),
        );
      } else if (widget.text.isNotEmpty) {
        // set text from address bar only when there's nothing to restore
        _controller.text = widget.text;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.text.length),
        );
      }

      // add listener only after initialization
      _controller.addListener(() {
        _text.value = _controller.text;
        _baseOffset.value = _controller.selection.baseOffset;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Go to the [SearchResultsPage] if entered text is not empty.
  void _goToSearchResults() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.goNamed('search_results', params: {'text': text});
    } else {
      showSnackBarMessage(context, 'enter_search_query'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.goNamed('home');
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Theme(
              data: ThemeData(
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Colors.white,
                  selectionColor: Colors.white38,
                  selectionHandleColor: Colors.white,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (text) => Router.neglect(
                  context,
                  () => context.goNamed(
                    'search_text',
                    queryParams: {
                      if (text.isNotEmpty) 'text': text,
                    },
                  ),
                ),
                onSubmitted: (_) => _goToSearchResults(),
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
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () => _goToSearchResults(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(fontSize: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text('search'.tr()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
