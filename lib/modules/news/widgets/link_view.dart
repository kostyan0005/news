import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/widgets/indicators.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LinkView extends StatefulWidget {
  final String link;

  const LinkView(this.link);

  @override
  _LinkViewState createState() => _LinkViewState();
}

class _LinkViewState extends State<LinkView> {
  bool _isLoading = !kIsWeb;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: widget.link,
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (_) {
            setState(() {
              _hasError = true;
            });
          },
        ),
        if (_hasError)
          const ErrorIndicator()
        else if (_isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const LoadingIndicator(),
          ),
      ],
    );
  }
}
