import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/config/constants.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/profile/pages/profile_dialog_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'home_tab_enum.dart';

/// Provider that indicates whether the profile dialog should be shown.
final shouldShowProfileDialogProvider = StateProvider((_) => false);

/// The home page of the application.
///
/// Contains 3 navigation tabs, which can be shown either in a bottom navigation
/// bar or in a drawer, depending on the screen size. State restoration is
/// implemented for this page.
class HomePage extends ConsumerStatefulWidget {
  /// Initially active tab index for the home page tab bar.
  ///
  /// Useful when we need to provide initially active tab while testing.
  final int initialTabIndex;

  const HomePage({
    required this.initialTabIndex,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with RestorationMixin {
  static const _screens = [
    HeadlineTabsPage(),
    SubscriptionsPage(),
    SavedNewsPage(),
  ];

  late final _controller =
      PersistentTabController(initialIndex: widget.initialTabIndex);
  late final _selectedIndex = RestorableInt(widget.initialTabIndex);
  final _showingProfileDialog = RestorableBool(false);

  @override
  void initState() {
    super.initState();

    // Use ref in a post-frame callback, as it is not available yet when
    // restoreState is called right after initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showingProfileDialog.value) {
        // Show the profile dialog if it was opened before the app state was lost.
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

    if (initialRestore && _selectedIndex.value != widget.initialTabIndex) {
      _controller.index = _selectedIndex.value;
    }
  }

  /// Opens the profile dialog and updates the state when it's closed.
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
    final isDesktop = MediaQuery.of(context).size.width >= kMinDesktopWidth;

    ref.listen(
      shouldShowProfileDialogProvider,
      (bool? isShown, bool shouldShow) =>
          isShown != true && shouldShow ? _showProfileDialog() : null,
    );

    return Scaffold(
      drawer: isDesktop
          ? Drawer(
              child: Column(
                children: [
                  for (final tab in HomeTab.values)
                    ListTile(
                      selected: tab.index == _selectedIndex.value,
                      leading: Icon(tab.icon),
                      title: Text(tab.title),
                      onTap: () {
                        if (tab.index != _selectedIndex.value) {
                          setState(() => _selectedIndex.value = tab.index);
                        }
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            )
          : null,
      body: isDesktop
          ? IndexedStack(
              index: _selectedIndex.value,
              children: _screens,
            )
          : PersistentTabView(
              context,
              controller: _controller,
              navBarStyle: NavBarStyle.style8,
              decoration: NavBarDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade100),
                ),
              ),
              screens: _screens,
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
            ),
    );
  }
}
