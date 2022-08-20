import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

/// Enables web views for the web platform.
void registerWebViewWebImplementation() {
  WebView.platform = WebWebViewPlatform();
}
