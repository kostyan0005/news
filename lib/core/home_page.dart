import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/profile/pages/profile_dialog_page.dart';

final shouldShowProfileDialogProvider = StateProvider((_) => false);

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RestorationMixin {
  final _selectedIndex = RestorableInt(0);
  final _showingProfileDialog = RestorableBool(false);

  @override
  void initState() {
    super.initState();

    // use WidgetsBinding, as ref is probably not available yet in restoreState
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_showingProfileDialog.value) {
        ref.read(shouldShowProfileDialogProvider.notifier).state = true;
      }
    });
  }

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
    registerForRestoration(_showingProfileDialog, 'showing_profile_dialog');
  }

  void _showProfileDialog() async {
    _showingProfileDialog.value = true;

    await showDialog(
      context: context,
      builder: (_) => const ProfileDialogPage(),
    );

    _showingProfileDialog.value = false;
    ref.read(shouldShowProfileDialogProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(shouldShowProfileDialogProvider,
        (bool? isShown, bool shouldShow) {
      if (isShown != true && shouldShow) {
        _showProfileDialog();
      }
    });

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex.value,
        children: const [
          HeadlineTabsPage(),
          SubscriptionsPage(),
          SavedNewsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex.value,
        onTap: (index) {
          if (index != _selectedIndex.value) {
            setState(() => _selectedIndex.value = index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.language),
            label: 'headlines'.tr(),
            tooltip: 'headlines'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.subscriptions_outlined),
            label: 'subscriptions'.tr(),
            tooltip: 'subscriptions'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star_border),
            label: 'saved_news'.tr(),
            tooltip: 'saved_news'.tr(),
          ),
        ],
      ),
    );
  }
}
