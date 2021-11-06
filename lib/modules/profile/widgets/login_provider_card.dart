import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginProviderCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData providerIcon;
  final String providerName;
  final bool isSignedIn;

  const LoginProviderCard({
    required this.onTap,
    required this.providerIcon,
    required this.providerName,
    required this.isSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade500,
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          dense: true,
          leading: Icon(
            providerIcon,
            color: Colors.white,
            size: 18,
          ),
          title: Text(
            providerName.isEmpty
                ? 'sign_out'
                : isSignedIn
                    ? 'connect_with'
                    : 'sign_in_with',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ).tr(args: [providerName]),
        ),
      ),
    );
  }
}
