import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

const _kAccountAlreadyInUseMessage =
    'This account is already connected to another user. '
    'If you want to sign in with this account, you need to sign out first.';

void showAccountAlreadyInUseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Account already in use'),
      content: Text(_kAccountAlreadyInUseMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read(authRepositoryProvider).signOut();
          },
          style: TextButton.styleFrom(primary: Colors.red),
          child: Text('Sign out'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(primary: Colors.blue),
          child: Text('Dismiss'),
        ),
      ],
    ),
  );
}
