import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/config/constants.dart';
import 'package:news/modules/news/widgets/link_view.dart';
import 'package:share_plus/share_plus.dart';

/// The page displaying the website of the particular news source.
class SourcePage extends StatelessWidget {
  final String? name;
  final String? link;

  const SourcePage({
    required this.name,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    if (name == null || link == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SelectableText(
            'source_not_found'.tr(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name!,
          style: const TextStyle(fontSize: 18),
          overflow: TextOverflow.fade,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              final encodedName = Uri.encodeComponent(name!);
              final encodedLink = Uri.encodeComponent(link!);
              final sharedLink =
                  '$kWebsiteUrl/source?name=$encodedName&link=$encodedLink';
              Share.share('$name: $sharedLink');
            },
          ),
        ],
      ),
      body: LinkView(link!),
    );
  }
}
