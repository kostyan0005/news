import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

void showAccountAlreadyInUseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('account_in_use'.tr()),
      content: Text('account_in_use_message'.tr()),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            context.read(authRepositoryProvider).signOut(context);
          },
          style: TextButton.styleFrom(primary: Colors.red),
          child: Text('sign_out'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: TextButton.styleFrom(primary: Colors.blue),
          child: Text('dismiss'.tr()),
        ),
      ],
    ),
  );
}
