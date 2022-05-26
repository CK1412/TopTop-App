import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../functions/functions.dart';
import '../l10n/l10n.dart';
import '../providers/state_notifier_providers.dart';
import '../src/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _logOutCurrentUser() async {
      final isLogOutAction = await showConfirmDialog(
        context: context,
        title: '${AppLocalizations.of(context)!.log_out}?',
        actionName: AppLocalizations.of(context)!.log_out,
      );

      if (isLogOutAction == true) {
        await ref.read(authControllerProvider.notifier).signOut(context);

        // remove all routes current
        Navigator.of(context).popUntil(
          (ModalRoute.withName('/')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language, size: 28),
            title: Text(AppLocalizations.of(context)!.language),
            minLeadingWidth: 20,
            onTap: null,
            trailing: customDropdownButton(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, size: 28),
            title: Text(AppLocalizations.of(context)!.log_out),
            minLeadingWidth: 20,
            onTap: _logOutCurrentUser,
          )
        ],
      ),
    );
  }

  Widget customDropdownButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.pink,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: ref.watch(localeControllerProvider),
            style: CustomTextStyle.bodyText2,
            dropdownColor: CustomColors.white,
            iconEnabledColor: CustomColors.pink,
            elevation: 0,
            isDense: true,
            alignment: AlignmentDirectional.center,
            items: L10n.all.map<DropdownMenuItem<Locale>>((locale) {
              return DropdownMenuItem(
                value: locale,
                child: Text(L10n.getLanguage(code: locale.languageCode)),
                onTap: () {
                  ref
                      .read(localeControllerProvider.notifier)
                      .changeLocale(locale);
                },
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
