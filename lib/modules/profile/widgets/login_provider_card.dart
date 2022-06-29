import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/profile/models/login_provider_enum.dart';
import 'package:news/utils/account_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';

final isLoadingProvider =
    StateProvider.autoDispose.family<bool, LoginProvider>((ref, _) => false);

class LoginProviderCard extends ConsumerWidget {
  final LoginProvider provider;
  final bool isSignedIn;

  LoginProviderCard({
    required this.provider,
    required this.isSignedIn,
  }) : super(key: ValueKey(provider));

  static bool isActionInProgress = false;

  void _signOut(WidgetRef ref, BuildContext context) async {
    if (isActionInProgress) return;
    isActionInProgress = true;
    ref.read(isLoadingProvider(provider).notifier).state = true;

    await ref.read(authRepositoryProvider).signOut();

    showSnackBarMessage(context, 'signed_out_message'.tr());
    isActionInProgress = false;
  }

  void _connectWithProvider(WidgetRef ref, BuildContext context) async {
    if (isActionInProgress) return;
    isActionInProgress = true;
    ref.read(isLoadingProvider(provider).notifier).state = true;

    final result = await provider.getConnectionFunction(ref).call();
    switch (result) {
      case SignInResult.success:
        showSnackBarMessage(
            context, 'connected_message'.tr(args: [provider.name]));
        break;
      case SignInResult.failed:
        showUnexpectedErrorMessage(context);
        break;
      case SignInResult.accountInUse:
        showAccountInUseDialog(context, () => _signOut(ref, context));
        break;
      case SignInResult.cancelled:
        break;
    }

    isActionInProgress = false;
    ref.read(isLoadingProvider(provider).notifier).state = false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.teal.shade500,
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        onTap: () => provider == LoginProvider.logout
            ? _signOut(ref, context)
            : _connectWithProvider(ref, context),
        child: ListTile(
          dense: true,
          leading: Icon(
            provider.icon,
            color: Colors.white,
            size: 18,
          ),
          title: !ref.watch(isLoadingProvider(provider))
              ? Text(
                  provider == LoginProvider.logout
                      ? 'sign_out'
                      : isSignedIn
                          ? 'connect_with'
                          : 'sign_in_with',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ).tr(args: [provider.name])
              : Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 40),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
