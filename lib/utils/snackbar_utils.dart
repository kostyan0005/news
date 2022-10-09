import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the snackbar [message] using the provided [messengerState].
void displaySnackBarMessage(
    ScaffoldMessengerState messengerState, String message) {
  messengerState.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Shows the snackbar [message] using the provided [context].
void showSnackBarMessage(BuildContext context, String message) =>
    displaySnackBarMessage(ScaffoldMessenger.of(context), message);

/// Shows the snackbar message indicating that some feature is not implemented yet.
void showNotImplementedMessage(BuildContext context) =>
    showSnackBarMessage(context, 'not_implemented_message'.tr());

/// Shows the snackbar [message] indicating that some error has occurred.
void showSnackBarErrorMessage(
    ScaffoldMessengerState messengerState, String message) {
  messengerState.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'dismiss'.tr(),
        textColor: Colors.white,
        onPressed: () => messengerState.hideCurrentSnackBar(),
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}

/// Shows the snackbar message indicating that an unexpected error has occurred.
void showUnexpectedErrorMessage(ScaffoldMessengerState messengerState) =>
    showSnackBarErrorMessage(messengerState, 'unexpected_error_message'.tr());
