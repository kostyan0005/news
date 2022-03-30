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
  double _percentLoaded = 0;
  bool _hasError = false;
  bool get _isFullyLoaded => _percentLoaded == 1;

  @override
  Widget build(BuildContext context) {
    const indicatorHeight = 10.0;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: _isFullyLoaded ? 0 : indicatorHeight),
          child: WebView(
            initialUrl: widget.link,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            gestureNavigationEnabled: true,
            onProgress: (p) => setState(() => _percentLoaded = p / 100),
            onWebResourceError: (_) => setState(() => _hasError = true),
          ),
        ),
        if (!_isFullyLoaded)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _percentLoaded,
              minHeight: indicatorHeight,
            ),
          ),
        if (_hasError) const ErrorIndicator(),
      ],
    );
  }
}
