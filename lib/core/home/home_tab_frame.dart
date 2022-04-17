import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.goNamed('search_text'),
          ),
          title: Text(title),
          centerTitle: true,
          actions: [
            IconButton(
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
