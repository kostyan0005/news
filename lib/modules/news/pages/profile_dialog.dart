import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/modules/news/widgets/login_provider_card.dart';

class ProfileDialog extends StatelessWidget {
  static const _tilePadding = EdgeInsets.symmetric(horizontal: 30);

  const ProfileDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).primaryColorDark,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 64,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  iconSize: 21,
                  splashRadius: 21,
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.white12),
              child: ExpansionTile(
                title: Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  'Currently not signed in',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                tilePadding: _tilePadding,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  LoginProviderCard(
                    // todo: implement
                    onTap: () => null,
                    providerIcon: FontAwesomeIcons.google,
                    providerName: 'Google',
                  ),
                  LoginProviderCard(
                    // todo: implement
                    onTap: () => null,
                    providerIcon: FontAwesomeIcons.facebook,
                    providerName: 'Facebook',
                  ),
                  if (Platform.isIOS)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => null,
                      providerIcon: FontAwesomeIcons.apple,
                      providerName: 'Apple',
                    ),
                  LoginProviderCard(
                    // todo: implement
                    onTap: () => null,
                    providerIcon: FontAwesomeIcons.twitter,
                    providerName: 'Twitter',
                  ),
                  LoginProviderCard(
                    // todo: implement
                    onTap: () => null,
                    providerIcon: FontAwesomeIcons.github,
                    providerName: 'Github',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ListTile(
              // todo: implement
              onTap: () => null,
              contentPadding: _tilePadding,
              title: Text(
                'Notification settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              // todo: implement
              onTap: () => null,
              contentPadding: _tilePadding,
              title: Text(
                'Language and region',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
