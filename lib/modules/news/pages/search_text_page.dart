import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news/utils/snackbar_utils.dart';

class SearchTextPage extends StatefulWidget {
  final String text;

  const SearchTextPage({
    required ValueKey<String> key,
    required this.text,
  }) : super(key: key);

  @override
  State<SearchTextPage> createState() => _SearchTextPageState();
}

class _SearchTextPageState extends State<SearchTextPage>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTextAndCursorPosition();
  }

  @override
  void didUpdateWidget(covariant SearchTextPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTextAndCursorPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _updateTextAndCursorPosition() {
    _controller.text = widget.text;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.text.length),
    );
  }

  void _goToSearchResults() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.pushNamed('search_results', params: {'text': text});
    } else {
      showSnackBarMessage(context, 'enter_search_query'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
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
              onPressed: () => _goToSearchResults(),
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

  @override
  bool get wantKeepAlive => true;
}
