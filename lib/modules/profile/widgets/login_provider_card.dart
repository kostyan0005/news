// ignore_for_file: use_build_context_synchronously

import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/profile/models/login_provider_enum.dart';
import 'package:news/utils/account_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';

/// The family of providers that indicates whether the process of connecting
/// with the particular login provider is currently happening or not.
final isLoadingProvider =
    StateProvider.autoDispose.family<bool, LoginProvider>((ref, _) => false);

/// The card which gives the user the option to sign in/connect with
/// the particular login [provider].
///
/// The logout option is also possible with the [LoginProvider.logout] provider.
class LoginProviderCard extends ConsumerWidget {
  final LoginProvider provider;

  /// The indicator of whether the user should be signed in or connected with
  /// the particular [provider].
  final bool isSignedIn;

  LoginProviderCard({
    required this.provider,
    required this.isSignedIn,
  }) : super(key: ValueKey(provider));

  /// The indicator of whether the process of connecting with any login provider
  /// is currently taking place.
  static bool _isActionInProgress = false;

  /// Signs the user out and shows the respective snack bar message.
  void _signOut(WidgetRef ref, BuildContext context) async {
    if (_isActionInProgress) return;
    _isActionInProgress = true;
    ref.read(isLoadingProvider(LoginProvider.logout).notifier).state = true;

    await ref.read(authRepositoryProvider).signOut();

    showSnackBarMessage(context, 'signed_out_message'.tr());
    _isActionInProgress = false;
  }

  /// Tries to sign in or connect with the particular login [provider].
  ///
  /// Additionally, the snackbar message is shown for each possible outcome.
  void _connectWithProvider(WidgetRef ref, BuildContext context) async {
    if (_isActionInProgress) return;
    _isActionInProgress = true;
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

    _isActionInProgress = false;
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
