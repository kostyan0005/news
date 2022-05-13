import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum HomeTab {
  headlines,
  subscriptions,
  savedNews,
}

extension HomeTabExtension on HomeTab {
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
