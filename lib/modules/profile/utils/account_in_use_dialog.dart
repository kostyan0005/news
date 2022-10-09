import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Shows the dialog telling that the provider the user tries to connect with
/// is already in use by an another account.
///
/// Gives the user the option to log out of the current account to sign in with
/// the desired provider.
void showAccountInUseDialog(BuildContext context, Function signOutFunc) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('account_in_use'.tr()),
      content: Text('account_in_use_message'.tr()),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            signOutFunc.call();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('sign_out'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: Text('dismiss'.tr()),
        ),
      ],
    ),
  );
}
