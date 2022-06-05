import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';
import 'package:news/utils/snackbar_utils.dart';

class SubscriptionItem extends ConsumerWidget {
  final SearchQuery subscription;

  const SubscriptionItem(this.subscription);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () => context.pushNamed(
          'topic',
          params: {
            'text': subscription.text,
          },
          queryParams: {
            'locale': subscription.locale,
            'subscribed': 'true',
          },
        ),
        child: ListTile(
          title: Text(subscription.text),
          trailing: IconButton(
            key: ValueKey('${subscription.text}_delete'),
            icon: const Icon(Icons.delete_outlined),
            onPressed: () {
              ref
                  .read(subscriptionsRepositoryProvider)
                  .unsubscribe(subscription.text);
              showSnackBarMessage(context, 'unsubscribed_message'.tr());
            },
          ),
        ),
      ),
    );
  }
}
