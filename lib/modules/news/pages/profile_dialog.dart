import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/modules/news/widgets/login_provider_card.dart';
import 'package:news/utils/snackbar_utils.dart';

class ProfileDialog extends StatelessWidget {
  static const _tilePadding = EdgeInsets.symmetric(horizontal: 30);

  const ProfileDialog();

  @override
  Widget build(BuildContext context) {
    // todo: correctly compute variables below
    final withGoogle = false;
    final withFacebook = false;
    final withApple = false;
    final withTwitter = false;
    final withGithub = false;
    final isSignedIn =
        withGoogle || withFacebook || withApple || withTwitter || withGithub;

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
                  'Sign in/out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                    children: [
                      if (!isSignedIn)
                        TextSpan(
                          text: 'Not signed in',
                        )
                      else
                        TextSpan(
                          text: 'Signed in with',
                        ),
                      if (withGoogle) IconSpan(FontAwesomeIcons.google),
                      if (withFacebook) IconSpan(FontAwesomeIcons.facebook),
                      if (withApple) IconSpan(FontAwesomeIcons.apple),
                      if (withTwitter) IconSpan(FontAwesomeIcons.twitter),
                      if (withGithub) IconSpan(FontAwesomeIcons.github),
                    ],
                  ),
                ),
                tilePadding: _tilePadding,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  if (isSignedIn)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => showNotImplementedMessage(context),
                      providerIcon: Icons.logout,
                      alternativeText: 'Sign out',
                    ),
                  if (isSignedIn)
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  if (!withGoogle)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => showNotImplementedMessage(context),
                      providerIcon: FontAwesomeIcons.google,
                      providerName: 'Google',
                    ),
                  if (!withFacebook)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => showNotImplementedMessage(context),
                      providerIcon: FontAwesomeIcons.facebook,
                      providerName: 'Facebook',
                    ),
                  if (Platform.isIOS && !withApple)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => showNotImplementedMessage(context),
                      providerIcon: FontAwesomeIcons.apple,
                      providerName: 'Apple',
                    ),
                  if (!withTwitter)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => showNotImplementedMessage(context),
                      providerIcon: FontAwesomeIcons.twitter,
                      providerName: 'Twitter',
                    ),
                  if (!withGithub)
                    LoginProviderCard(
                      // todo: implement
                      onTap: () => showNotImplementedMessage(context),
                      providerIcon: FontAwesomeIcons.github,
                      providerName: 'GitHub',
                    ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ListTile(
              // todo: implement
              onTap: () => showNotImplementedMessage(context),
              contentPadding: _tilePadding,
              title: Text(
                'Notification settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              // todo: implement
              onTap: () => showNotImplementedMessage(context),
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

class IconSpan extends WidgetSpan {
  final IconData icon;

  IconSpan(this.icon)
      : super(
          child: Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 18,
            ),
          ),
        );
}
