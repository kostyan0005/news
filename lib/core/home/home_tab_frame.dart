import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/modules/profile/pages/profile_dialog_page.dart';

class HomeTabFrame extends StatelessWidget {
  final String title;
  final Widget body;
  final PreferredSizeWidget? appBarBottom;

  const HomeTabFrame({
    required this.title,
    required this.body,
    this.appBarBottom,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (_, __) {
        return [
          SliverAppBar(
            leading: IconButton(
              onPressed: () => context.goNamed('search_text'),
              icon: const Icon(Icons.search),
            ),
            title: Text(title),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const ProfileDialogPage(),
                ),
                icon: Consumer(
                  builder: (_, ref, __) =>
                      ref.watch(photoUrlStreamProvider).maybeWhen(
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
                ),
              ),
            ],
            bottom: appBarBottom,
          ),
        ];
      },
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
