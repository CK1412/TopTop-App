import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../../src/constants.dart';
import '../../widgets/auth/gradient_background.dart';

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
      return 'Please enter your phone number';
    }
    if (text.length < 9) {
      return 'Phone number must be 9 or 10 digits';
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

        await ref.read(authControllerProvider.notifier).signInWithPhone(
              context,
              phoneNumber: _phoneNumberController.text.trim(),
            );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: CustomColors.white,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(
              child: GradientBackground(),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 34 + AppBar().preferredSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter your phone',
                    style: CustomTextStyle.titleLarge.copyWith(
                      color: CustomColors.white,
                      fontSize: 34,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                    child: Text(
                      ' You will receive a 4 digit code for phone number verification.',
                      style: CustomTextStyle.bodyText2.copyWith(
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.white,
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
                          hintText: 'VD: 565843282',
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
                      primary: CustomColors.white,
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
                      'Continue',
                      style: CustomTextStyle.title2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => _signInWithPhone(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
