import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/modules/profile/providers/locale_stream_provider.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';
import 'package:news/utils/snackbar_utils.dart';

class LocaleSelectionPage extends ConsumerWidget {
  const LocaleSelectionPage();

  void _changeLocale(String locale, WidgetRef ref, BuildContext context) async {
    await ref.read(userSettingsRepositoryProvider).updateLocale(locale);
    showSnackBarMessage(context, 'locale_changed_message'.tr());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeStream = ref.watch(localeStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('language_region'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'select_locale'.tr(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ListTile(
            onTap: () => _changeLocale('ru_UA', ref, context),
            leading: const Icon(Icons.language),
            title: const Text('Русский (Украина)'),
            trailing: localeStream.maybeWhen(
              data: (locale) =>
                  locale == 'ru_UA' ? const Icon(Icons.check) : null,
              orElse: () => null,
            ),
          ),
          ListTile(
            onTap: () => _changeLocale('en_US', ref, context),
            leading: const Icon(Icons.language),
            title: const Text('English (United States)'),
            trailing: localeStream.maybeWhen(
              data: (locale) =>
                  locale == 'en_US' ? const Icon(Icons.check) : null,
              orElse: () => null,
            ),
          ),
        ],
      ),
    );
  }
}
