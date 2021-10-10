import 'package:flutter/material.dart';

class LoginProviderCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData providerIcon;
  final String providerName;

  const LoginProviderCard({
    required this.onTap,
    required this.providerIcon,
    required this.providerName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade500,
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          dense: true,
          leading: Icon(
            providerIcon,
            color: Colors.white,
            size: 18,
          ),
          title: Text(
            'Sign in with $providerName',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
