import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/pages/all.dart';

final bottomBarIndexProvider = StateProvider((_) => 0);

class HomePage extends ConsumerWidget {
  const HomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomBarIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          HeadlineTabsPage(),
          SubscriptionsPage(),
          SavedNewsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (newIndex) =>
            ref.read(bottomBarIndexProvider.notifier).state = newIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.language),
            label: 'headlines'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.subscriptions_outlined),
            label: 'subscriptions'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star_border),
            label: 'saved_news'.tr(),
          ),
        ],
      ),
    );
  }
}
