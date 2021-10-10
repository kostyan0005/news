import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/pages/search_query_page.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';
import 'package:news/utils/snackbar_utils.dart';

class SubscriptionItem extends StatelessWidget {
  final SearchQuery subscription;

  const SubscriptionItem(this.subscription);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(SearchQueryPage.routeName, arguments: subscription),
        child: ListTile(
          title: Text(subscription.text),
          trailing: IconButton(
            onPressed: () {
              context
                  .read(subscriptionsRepositoryProvider)
                  .unsubscribe(subscription.text);
              showQuickSnackBarMessage(context, 'Removed from subscriptions');
            },
            icon: Icon(Icons.delete_outlined),
          ),
        ),
      ),
    );
  }
}
