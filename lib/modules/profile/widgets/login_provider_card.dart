import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/profile/models/login_provider_enum.dart';
import 'package:news/utils/account_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';

class LoginProviderCard extends StatelessWidget {
  final LoginProvider provider;
  final AuthRepository authRepo;
  final bool isSignedIn;

  const LoginProviderCard({
    required this.provider,
    required this.authRepo,
    required this.isSignedIn,
  });

  void _connectWithProvider(BuildContext context) {
    provider.getConnectionFunction(authRepo).call().then((result) {
      switch (result) {
        case SignInResult.success:
          showSnackBarMessage(
              context, 'connected_message'.tr(args: [provider.name]));
          break;
        case SignInResult.failed:
          showUnexpectedErrorMessage(context);
          break;
        case SignInResult.accountInUse:
          showAccountInUseDialog(context, () => _signOut(context));
          break;
        case SignInResult.cancelled:
          break;
      }
    });
  }

  void _signOut(BuildContext context) async {
    await authRepo.signOut();
    showSnackBarMessage(context, 'signed_out_message'.tr());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade500,
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        onTap: () => provider == LoginProvider.logout
            ? _signOut(context)
            : _connectWithProvider(context),
        child: ListTile(
          dense: true,
          leading: Icon(
            provider.icon,
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
