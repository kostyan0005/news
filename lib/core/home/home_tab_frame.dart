import 'package:flutter/material.dart';
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
                  context: context,
                  builder: (_) => ProfileDialog(),
                ),
                icon: CircleAvatar(
                  // todo: display avatar when signed in
                  child: Icon(Icons.person),
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
