import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/auth/anonymous_sign_in_provider.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/widgets/indicators.dart';

import 'bottom_bar_index_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage();

  static const routeName = '/';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final index = watch(bottomBarIndexProvider);
    return Scaffold(
      body: watch(anonymousSingInProvider).maybeWhen(
        data: (_) => IndexedStack(
          index: index,
          children: [
            HeadlineTabsPage(),
            SubscriptionsPage(),
            SavedNewsPage(),
          ],
        ),
        orElse: () => LoadingIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: context.read(bottomBarIndexProvider.notifier).changeIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'headlines'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            label: 'subscriptions'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'saved_news'.tr(),
          ),
        ],
      ),
    );
  }
}
