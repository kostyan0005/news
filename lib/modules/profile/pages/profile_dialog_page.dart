import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/core/auth/auth_repository.dart';
import 'package:news/core/auth/sign_in_status_stream_provider.dart';
import 'package:news/modules/profile/pages/locale_selection_page.dart';
import 'package:news/modules/profile/widgets/login_provider_card.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:news/widgets/indicators.dart';

class ProfileDialogPage extends ConsumerWidget {
  const ProfileDialogPage();

  static const _tilePadding = EdgeInsets.symmetric(horizontal: 30);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(signInStatusStreamProvider).maybeWhen(
      data: (status) {
        final isSignedIn = status.isSignedIn;
        final withGoogle = status.withGoogle;
        final withFacebook = status.withFacebook;
        final withApple = status.withApple;
        final withTwitter = status.withTwitter;

        return ScaffoldMessenger(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: GestureDetector(
                  onTap: () {},
                  child: Dialog(
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
                                'profile'.tr(),
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
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.white12),
                            child: ExpansionTile(
                              title: Text(
                                'sign_in_out'.tr(),
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
                                        text: 'not_signed_in'.tr(),
                                      )
                                    else
                                      TextSpan(
                                        text: 'connected_with'.tr(),
                                      ),
                                    if (withGoogle)
                                      IconSpan(FontAwesomeIcons.google),
                                    if (withFacebook)
                                      IconSpan(FontAwesomeIcons.facebook),
                                    if (withTwitter)
                                      IconSpan(FontAwesomeIcons.twitter),
                                    if (withApple && Platform.isIOS)
                                      IconSpan(FontAwesomeIcons.apple),
                                  ],
                                ),
                              ),
                              tilePadding: _tilePadding,
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: [
                                if (isSignedIn)
                                  LoginProviderCard(
                                    onTap: () => context
                                        .read(authRepositoryProvider)
                                        .signOut(context),
                                    providerIcon: Icons.logout,
                                    providerName: '',
                                    isSignedIn: isSignedIn,
                                  ),
                                if (isSignedIn)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: Text(
                                      'or'.tr(),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                if (!withGoogle)
                                  LoginProviderCard(
                                    onTap: () => context
                                        .read(authRepositoryProvider)
                                        .connectWithGoogle(context),
                                    providerIcon: FontAwesomeIcons.google,
                                    providerName: 'Google',
                                    isSignedIn: isSignedIn,
                                  ),
                                if (!withFacebook)
                                  LoginProviderCard(
                                    onTap: () => context
                                        .read(authRepositoryProvider)
                                        .connectWithFacebook(context),
                                    providerIcon: FontAwesomeIcons.facebook,
                                    providerName: 'Facebook',
                                    isSignedIn: isSignedIn,
                                  ),
                                if (!withTwitter)
                                  LoginProviderCard(
                                    onTap: () => context
                                        .read(authRepositoryProvider)
                                        .connectWithTwitter(context),
                                    providerIcon: FontAwesomeIcons.twitter,
                                    providerName: 'Twitter',
                                    isSignedIn: isSignedIn,
                                  ),
                                if (!withApple && Platform.isIOS)
                                  LoginProviderCard(
                                    // todo: implement
                                    onTap: () =>
                                        showNotImplementedMessage(context),
                                    providerIcon: FontAwesomeIcons.apple,
                                    providerName: 'Apple',
                                    isSignedIn: isSignedIn,
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
                              'notification_settings'.tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(LocaleSelectionPage.routeName),
                            contentPadding: _tilePadding,
                            title: Text(
                              'language_region'.tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => LoadingIndicator(),
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
