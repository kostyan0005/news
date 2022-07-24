import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/config/constants.dart';

import 'home_page.dart';

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

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      child: Icon(Icons.person),
    );
  }
}
