import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toptop_app/widgets/common/dismiss_keyboard.dart';

import '../../providers/state_notifier_providers.dart';
import '../../src/constants.dart';

class VerificationOtpCodeScreen extends ConsumerStatefulWidget {
  const VerificationOtpCodeScreen({
    Key? key,
    required this.phoneNumber,
    required this.verifycationId,
  }) : super(key: key);

  final String phoneNumber;
  final String verifycationId;

  @override
  ConsumerState<VerificationOtpCodeScreen> createState() =>
      _VerificationOtpCodeScreenState();
}

class _VerificationOtpCodeScreenState
    extends ConsumerState<VerificationOtpCodeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  bool _isLoading = false;
  String smsCode = '';

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
    pinController.dispose();
    focusNode.dispose();
  }

  void _loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _verifyOTP(String value) async {
      _loading();

      final isSuccessfully =
          await ref.read(authControllerProvider.notifier).verifyOTP(
                context,
                verificationId: widget.verifycationId,
                smsCode: value,
              );

      if (isSuccessfully) {
        // remove all routes current
        Navigator.of(context).popUntil((ModalRoute.withName('/')));
      } else {
        _loading();
      }
    }

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(222, 231, 240, .57),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
      textStyle: CustomTextStyle.bodyText1.copyWith(fontSize: 18),
    );

    return DismissKeyboard(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.white,
        appBar: AppBar(
          foregroundColor: CustomColors.black,
        ),
        body: SizedBox.expand(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.verification,
                      style: CustomTextStyle.titleLarge.copyWith(fontSize: 34),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!
                          .enter_the_code_sent_to_the_number,
                      style: CustomTextStyle.bodyText1,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.phoneNumber,
                      style: CustomTextStyle.bodyText1,
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 56,
                      child: Pinput(
                        length: 6,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          width: 56,
                          height: 56,
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(color: CustomColors.blue),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: CustomColors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: pinController,
                        focusNode: focusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        onCompleted: (pin) {
                          _verifyOTP(pin);
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      '${AppLocalizations.of(context)!.did_not_receive_code}?',
                      style: CustomTextStyle.bodyText2,
                    ),
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.resend,
                        style: CustomTextStyle.bodyText2.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                const CenterLoadingWidget(
                  backgroundTransparent: false,
                )
            ],
          ),
        ),
      ),
    );
  }
}
