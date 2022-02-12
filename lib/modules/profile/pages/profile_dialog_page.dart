import 'package:auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/modules/profile/models/login_provider_enum.dart';
import 'package:news/modules/profile/pages/locale_selection_page.dart';
import 'package:news/modules/profile/widgets/login_provider_card.dart';
import 'package:news/utils/snackbar_utils.dart';
import 'package:news/widgets/indicators.dart';

class ProfileDialogPage extends ConsumerWidget {
  const ProfileDialogPage();

  static const _tilePadding = EdgeInsets.symmetric(
    horizontal: 30,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(signInStatusStreamProvider).maybeWhen(
          data: (status) {
            final isSignedIn = status.isSignedIn;
            final withGoogle = status.withGoogle;
            final withFacebook = status.withFacebook;
            final withTwitter = status.withTwitter;
            final withAll = withGoogle && withFacebook && withTwitter;

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
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                    color: Colors.white,
                                    iconSize: 21,
                                    splashRadius: 21,
                                  ),
                                  Text(
                                    'profile'.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
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
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
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
                                          _IconSpan(FontAwesomeIcons.google),
                                        if (withFacebook)
                                          _IconSpan(FontAwesomeIcons.facebook),
                                        if (withTwitter)
                                          _IconSpan(FontAwesomeIcons.twitter),
                                      ],
                                    ),
                                  ),
                                  tilePadding: _tilePadding,
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  children: [
                                    if (isSignedIn)
                                      LoginProviderCard(
                                        provider: LoginProvider.logout,
                                        isSignedIn: isSignedIn,
                                      ),
                                    if (isSignedIn && !withAll)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Text(
                                          'or'.tr(),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    if (!withGoogle)
                                      LoginProviderCard(
                                        provider: LoginProvider.google,
                                        isSignedIn: isSignedIn,
                                      ),
                                    if (!withFacebook)
                                      LoginProviderCard(
                                        provider: LoginProvider.facebook,
                                        isSignedIn: isSignedIn,
                                      ),
                                    if (!withTwitter)
                                      LoginProviderCard(
                                        provider: LoginProvider.twitter,
                                        isSignedIn: isSignedIn,
                                      ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () => showNotImplementedMessage(context),
                                contentPadding: _tilePadding,
                                title: Text(
                                  'notification_settings'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(LocaleSelectionPage.routeName),
                                contentPadding: _tilePadding,
                                title: Text(
                                  'language_region'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
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
          orElse: () => const LoadingIndicator(),
        );
  }
}

class _IconSpan extends WidgetSpan {
  final IconData icon;

  _IconSpan(this.icon)
      : super(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 7,
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 18,
            ),
          ),
        );
}
