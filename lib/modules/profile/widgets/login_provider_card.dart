import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/profile/models/login_provider_enum.dart';
import 'package:news/utils/account_in_use_dialog.dart';
import 'package:news/utils/snackbar_utils.dart';

class LoginProviderCard extends StatefulWidget {
  final LoginProvider provider;
  final bool isSignedIn;

  LoginProviderCard({
    required this.provider,
    required this.isSignedIn,
  }) : super(key: ValueKey(provider));

  @override
  State<LoginProviderCard> createState() => _LoginProviderCardState();
}

class _LoginProviderCardState extends State<LoginProviderCard> {
  static bool isActionInProgress = false;

  late final LoginProvider provider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
  }

  void _signOut() async {
    if (isActionInProgress) return;
    isActionInProgress = true;
    setState(() => isLoading = true);

    await AuthRepository.instance.signOut();

    showSnackBarMessage(context, 'signed_out_message'.tr());
    isActionInProgress = false;
  }

  void _connectWithProvider() async {
    if (isActionInProgress) return;
    isActionInProgress = true;
    setState(() => isLoading = true);

    final result = await widget.provider.getConnectionFunction().call();
    switch (result) {
      case SignInResult.success:
        showSnackBarMessage(
            context, 'connected_message'.tr(args: [widget.provider.name]));
        break;
      case SignInResult.failed:
        showUnexpectedErrorMessage(context);
        break;
      case SignInResult.accountInUse:
        showAccountInUseDialog(context, () => _signOut());
        break;
      case SignInResult.cancelled:
        break;
    }

    isActionInProgress = false;
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade500,
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        onTap: () => provider == LoginProvider.logout
            ? _signOut()
            : _connectWithProvider(),
        child: ListTile(
          dense: true,
          leading: Icon(
            provider.icon,
            color: Colors.white,
            size: 18,
          ),
          title: !isLoading
              ? Text(
                  provider == LoginProvider.logout
                      ? 'sign_out'
                      : widget.isSignedIn
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
