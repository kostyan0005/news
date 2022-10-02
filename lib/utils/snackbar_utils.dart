import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// todo
void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

void showNotImplementedMessage(BuildContext context) =>
    showSnackBarMessage(context, 'not_implemented_message'.tr());

void showSnackBarErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'dismiss'.tr(),
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}

void showUnexpectedErrorMessage(BuildContext context) =>
    showSnackBarErrorMessage(context, 'unexpected_error_message'.tr());
