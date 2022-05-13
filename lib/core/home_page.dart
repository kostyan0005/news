import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/profile/pages/profile_dialog_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'home_tab_enum.dart';

final shouldShowProfileDialogProvider = StateProvider((_) => false);

class HomePage extends ConsumerStatefulWidget {
  final int initialIndex;

  const HomePage({
    this.initialIndex = 0,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RestorationMixin {
  late final _controller =
      PersistentTabController(initialIndex: widget.initialIndex);
  late final _selectedIndex = RestorableInt(widget.initialIndex);
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
  String get restorationId => 'HomePage';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selectedIndex');
    registerForRestoration(_showingProfileDialog, 'showingProfileDialog');

    if (initialRestore && _selectedIndex.value != widget.initialIndex) {
      _controller.index = _selectedIndex.value;
    }
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

    return PersistentTabView(
      context,
      controller: _controller,
      navBarStyle: NavBarStyle.style8,
      decoration: NavBarDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      screens: const [
        HeadlineTabsPage(),
        SubscriptionsPage(),
        SavedNewsPage(),
      ],
      items: [
        for (final tab in HomeTab.values)
          PersistentBottomNavBarItem(
            icon: Icon(tab.icon),
            title: tab.title,
            activeColorPrimary: Colors.teal,
            inactiveColorPrimary: CupertinoColors.systemGrey,
          ),
      ],
      onItemSelected: (index) {
        if (index != _controller.index) {
          _controller.index = index;
          _selectedIndex.value = index;
        }
      },
    );
  }
}
