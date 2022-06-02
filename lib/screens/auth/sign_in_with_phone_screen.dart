import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toptop_app/widgets/common/dismiss_keyboard.dart';

import '../../src/constants.dart';

class SignInWithPhoneScreen extends ConsumerStatefulWidget {
  const SignInWithPhoneScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInWithPhoneScreen> createState() =>
      _SignInWithPhoneScreenState();
}

class _SignInWithPhoneScreenState extends ConsumerState<SignInWithPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  bool _autoFocus = true;

  String? _validator(String? text) {
    if (text!.isEmpty) {
      return AppLocalizations.of(context)!.please_enter_your_phone_number;
    }
    if (text.length < 9) {
      return AppLocalizations.of(context)!.phone_number_must_be_9_or_10_digits;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _signInWithPhone() async {
      if (_formKey.currentState!.validate()) {
        _autoFocus = false;
        FocusManager.instance.primaryFocus?.unfocus();

        String phoneNumberVN = '+84' + _phoneNumberController.text.trim();

        await ref.read(authControllerProvider.notifier).signInWithPhone(
              context,
              phoneNumber: phoneNumberVN,
            );
      }
    }

    return DismissKeyboard(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.white,
        appBar: AppBar(
          foregroundColor: CustomColors.black,
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.enter_your_phone,
                  style: CustomTextStyle.titleLarge.copyWith(
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.greyLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText:
                            '${AppLocalizations.of(context)!.ex}: 565843282',
                        border: InputBorder.none,
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              IconPath.flagVNColor,
                              width: 26,
                            ),
                            const SizedBox(width: 5),
                            const Text('+84'),
                          ],
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      autofocus: _autoFocus,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        // Vietnam phone number only 10 numbers
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: _validator,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continue_,
                    style: CustomTextStyle.title2.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.white,
                    ),
                  ),
                  onPressed: () => _signInWithPhone(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
