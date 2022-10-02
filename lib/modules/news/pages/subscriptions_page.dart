import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/core/home_tab_frame.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/repositories/subscriptions_repository.dart';
import 'package:news/modules/news/widgets/subscription_item.dart';
import 'package:news/widgets/indicators.dart';

/// The provider of the subscriptions stream of the current user.
final subscriptionsStreamProvider = StreamProvider<List<SearchQuery>>((ref) =>
    ref.watch(subscriptionsRepositoryProvider).getSubscriptionsStream());

/// The page where all the subscriptions of the current user are displayed.
///
/// Subscriptions are topics to which current user is subscribed.
/// They are sorted from latest to earliest subscribed.
class SubscriptionsPage extends ConsumerWidget {
  const SubscriptionsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeTabFrame(
      title: 'subscriptions'.tr(),
      body: ref.watch(subscriptionsStreamProvider).when(
            data: (subscriptions) => subscriptions.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) =>
                                SubscriptionItem(subscriptions[index]),
                            childCount: subscriptions.length,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: SelectableText(
                      'no_subscriptions'.tr(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
            loading: () => const LoadingIndicator(),
            error: (_, __) => const ErrorIndicator(),
          ),
    );
  }
}
