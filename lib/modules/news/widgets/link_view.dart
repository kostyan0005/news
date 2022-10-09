import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/widgets/indicators.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'options_sheet.dart';

/// The provider which indicates whether the modal bottom sheet is opened on top
/// of [LinkView] widget on the web.
final webBottomSheetVisibilityProvider = StateProvider((_) => false);

/// The web view which displays the contents of the particular [link].
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
            // Add some space for loading indicator when needed.
            top: _isFullyLoaded ? 0 : indicatorHeight,
            // Add some bottom padding on the web when the bottom sheet is opened
            // in order to free up some space for it, cause bottom sheet touch
            // events are not received when the sheet is displayed on top of
            // the web view.
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
