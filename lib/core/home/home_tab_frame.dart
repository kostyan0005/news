import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/auth/photo_url_stream_provider.dart';
import 'package:news/modules/news/pages/profile_dialog.dart';
import 'package:news/modules/news/pages/search_text_page.dart';

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
              onPressed: () =>
                  Navigator.pushNamed(context, SearchTextPage.routeName),
              icon: Icon(Icons.search),
            ),
            title: Text(title),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => showDialog(
                    context: context, builder: (_) => ProfileDialog()),
                icon: Consumer(
                  builder: (_, watch, __) =>
                      watch(photoUrlStreamProvider).maybeWhen(
                    data: (photoUrl) => photoUrl != null
                        ? Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(photoUrl),
                              ),
                              shape: BoxShape.circle,
                            ),
                          )
                        : _DefaultAvatar(),
                    orElse: () => _DefaultAvatar(),
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
    return CircleAvatar(
      child: Icon(Icons.person),
    );
  }
}
