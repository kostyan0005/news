import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/config/constants.dart';
import 'package:news/core/home_page.dart';

/// The widget which encapsulates home page tabs, providing each of them with
/// an identical app bar, which scrolls together with the content.
///
/// In addition, each tab's appbar will stay in it's own scroll position.
/// The position of the appbar icons is determined based on the screen size.
class HomeTabFrame extends ConsumerWidget {
  final String title;
  final Widget body;
  final PreferredSizeWidget? appBarBottom;

  const HomeTabFrame({
    required this.title,
    required this.body,
    this.appBarBottom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= kMinDesktopWidth;
    final searchButton = IconButton(
      icon: const Icon(Icons.search),
      onPressed: () => context.goNamed('search_text'),
    );

    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          leading: !isDesktop ? searchButton : null,
          title: Text(title),
          centerTitle: true,
          actions: [
            if (isDesktop) searchButton,
            IconButton(
              key: const ValueKey('profileButton'),
              icon: ref.watch(photoUrlStreamProvider).maybeWhen(
                    data: (photoUrl) => photoUrl != null
                        ? Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(photoUrl),
                              ),
                              shape: BoxShape.circle,
                            ),
                          )
                        : const _DefaultAvatar(),
                    orElse: () => const _DefaultAvatar(),
                  ),
              onPressed: () => ref
                  .read(shouldShowProfileDialogProvider.notifier)
                  .state = true,
            ),
          ],
          bottom: appBarBottom,
        ),
      ],
      body: body,
    );
  }
}

/// The default look of the profile icon.
///
/// If user is logged in, his social account avatar will be shown instead.
class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      child: Icon(Icons.person),
    );
  }
}
