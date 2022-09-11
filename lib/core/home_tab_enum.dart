import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/core/home_page.dart';

/// Available [HomePage] tabs.
enum HomeTab {
  headlines,
  subscriptions,
  savedNews,
}

extension HomeTabExtension on HomeTab {
  /// The icon for the current tab.
  IconData get icon {
    switch (this) {
      case HomeTab.headlines:
        return Icons.language;
      case HomeTab.subscriptions:
        return Icons.subscriptions_outlined;
      case HomeTab.savedNews:
        return Icons.star_border;
    }
  }

  /// The localized title of the current tab.
  String get title {
    switch (this) {
      case HomeTab.headlines:
        return 'headlines'.tr();
      case HomeTab.subscriptions:
        return 'subscriptions'.tr();
      case HomeTab.savedNews:
        return 'saved_news'.tr();
    }
  }
}
