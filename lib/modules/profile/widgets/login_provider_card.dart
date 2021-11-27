import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/config/twitter_params.dart';
import 'package:news/core/auth/auth_repository.dart';
import 'package:news/core/auth/login_provider_enum.dart';
import 'package:news/utils/account_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';

class LoginProviderCard extends ConsumerWidget {
  final LoginProvider provider;
  final IconData providerIcon;
  final bool isSignedIn;

  const LoginProviderCard({
    required this.provider,
    required this.providerIcon,
    required this.isSignedIn,
  });

  void _connectWithProvider(
      LoginProvider provider, WidgetRef ref, BuildContext context) {
    final repo = ref.read(authRepositoryProvider);
    late final Future<SignInResult> Function() connectionFunction;

    switch (provider) {
      case LoginProvider.google:
        connectionFunction = repo.connectWithGoogle;
        break;
      case LoginProvider.facebook:
        connectionFunction = repo.connectWithFacebook;
        break;
      case LoginProvider.twitter:
        connectionFunction = () => repo.connectWithTwitter(
            twitterApiKey, twitterSecretKey, twitterRedirectUri);
        break;
      default:
        break;
    }

    connectionFunction.call().then((result) {
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
    });
  }

  void _signOut(WidgetRef ref, BuildContext context) async {
    await ref.read(authRepositoryProvider).signOut();
    showSnackBarMessage(context, 'signed_out_message'.tr());
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
            : _connectWithProvider(provider, ref, context),
        child: ListTile(
          dense: true,
          leading: Icon(
            providerIcon,
            color: Colors.white,
            size: 18,
          ),
          title: Text(
            provider == LoginProvider.logout
                ? 'sign_out'
                : isSignedIn
                    ? 'connect_with'
                    : 'sign_in_with',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ).tr(args: [provider.name]),
        ),
      ),
    );
  }
}
