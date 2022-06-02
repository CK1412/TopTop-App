import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/common/custom_elevate_button.dart';
import '../../src/constants.dart';
import '../../src/page_routes.dart';
import 'sign_in_with_phone_screen.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authController = ref.watch(authControllerProvider.notifier);

    void _signInWithPhone() {
      Navigator.of(context).push(
        CustomPageRoute(child: const SignInWithPhoneScreen()),
      );
    }

    Future<void> _signInWithGoogle() async {
      await _authController.signInWithGoogle(context);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.white,
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(IconPath.appLogo, width: 200),
              ),
              Text(
                AppLocalizations.of(context)!.welcome_to_TopTop,
                style: CustomTextStyle.titleLarge.copyWith(fontSize: 34),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                child: Text(
                  '${AppLocalizations.of(context)!.create_an_account_or_log_in_to_get_started}.',
                  style: CustomTextStyle.bodyText2,
                ),
              ),
              CustomElevateButton(
                iconPath: IconPath.phoneColor,
                text: AppLocalizations.of(context)!.continue_with_Phone,
                onPressed: _signInWithPhone,
              ),
              CustomElevateButton(
                iconPath: IconPath.googleColor,
                text: AppLocalizations.of(context)!.continue_with_Google,
                onPressed: _signInWithGoogle,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .by_continuing_you_agree_to_our,
                          style: CustomTextStyle.bodyText2
                              .copyWith(color: CustomColors.grey),
                        ),
                        TextSpan(
                          text:
                              ' ${AppLocalizations.of(context)!.terms_of_Service}',
                          style: CustomTextStyle.bodyText2,
                        ),
                        TextSpan(
                          text:
                              ' ${AppLocalizations.of(context)!.and_accept_our}',
                          style: CustomTextStyle.bodyText2
                              .copyWith(color: CustomColors.grey),
                        ),
                        TextSpan(
                          text:
                              ' ${AppLocalizations.of(context)!.privacy_Policy}',
                          style: CustomTextStyle.bodyText2,
                        ),
                        TextSpan(
                          text:
                              ' ${AppLocalizations.of(context)!.for_our_use_of_your_data}.',
                          style: CustomTextStyle.bodyText2
                              .copyWith(color: CustomColors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
