import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/widgets/indicators.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'options_sheet.dart';

final webBottomSheetVisibilityProvider = StateProvider((_) => false);

class LinkView extends ConsumerStatefulWidget {
  final String link;

  const LinkView(this.link);

  @override
  ConsumerState<LinkView> createState() => _LinkViewState();
}

class _LinkViewState extends ConsumerState<LinkView> {
  double _percentLoaded = 0;
  bool _hasError = false;
  bool get _isFullyLoaded => _percentLoaded == 1 || kIsWeb;

  @override
  Widget build(BuildContext context) {
    const indicatorHeight = 10.0;
    final isWebBottomSheetVisible = ref.watch(webBottomSheetVisibilityProvider);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: _isFullyLoaded ? 0 : indicatorHeight,
            bottom: kIsWeb && isWebBottomSheetVisible
                ? OptionsSheet.height + MediaQuery.of(context).padding.bottom
                : 0,
          ),
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
