import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/state.dart';
import '../../src/constants.dart';
import '../../widgets/auth/gradient_background.dart';
import '../../widgets/common/loading_widget.dart';

class VerificationOtpCodeScreen extends ConsumerStatefulWidget {
  const VerificationOtpCodeScreen({
    Key? key,
    required this.phoneNumber,
    this.verifycationId = '',
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
  final _formKey = GlobalKey<FormState>();

  final _numberInputOneController = TextEditingController();
  final _numberInputTwoController = TextEditingController();
  final _numberInputThreeController = TextEditingController();
  final _numberInputFourController = TextEditingController();
  final _numberInputFiveController = TextEditingController();
  final _numberInputSixController = TextEditingController();

  bool _isLoading = false;
  String smsCode = '';

  @override
  void dispose() {
    super.dispose();
    _isLoading = false;
    _numberInputOneController.dispose();
    _numberInputTwoController.dispose();
    _numberInputThreeController.dispose();
    _numberInputFourController.dispose();
    _numberInputFiveController.dispose();
    _numberInputSixController.dispose();
  }

  String get _getSmsCode {
    String number1 = _numberInputOneController.text;
    String number2 = _numberInputTwoController.text;
    String number3 = _numberInputThreeController.text;
    String number4 = _numberInputFourController.text;
    String number5 = _numberInputFiveController.text;
    String number6 = _numberInputSixController.text;
    smsCode = number1 + number2 + number3 + number4 + number5 + number6;
    return smsCode;
  }

  void _loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(authProvider);

    void _verifyOTP() async {
      if (_formKey.currentState!.validate()) {
        _loading();
        FocusManager.instance.primaryFocus?.unfocus();
        final bool isSuccessfully = await _auth.verifyOTP(
          context: context,
          verificationId: widget.verifycationId,
          smsCode: _getSmsCode,
        );

        if (isSuccessfully) {
          debugPrint('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH');
          Navigator.of(context).popUntil((ModalRoute.withName('/')));
        } else {
          debugPrint('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
          _loading();
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
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
                    'OTP Verification',
                    style: CustomTextStyle.titleLarge
                        .copyWith(color: CustomColors.white, fontSize: 34),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                    child: Text(
                      'You will receive a 4 digit code for phone number verification.',
                      style: CustomTextStyle.bodyText2
                          .copyWith(color: CustomColors.white),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 60),
                      child: buildListInputBox(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            side: const BorderSide(
                              width: 1,
                              color: CustomColors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                          ),
                          child: Text(
                            'Resend',
                            style: CustomTextStyle.title2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: CustomColors.white,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
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
                          onPressed: _verifyOTP,
                          child: Text(
                            'Confirm',
                            style: CustomTextStyle.title2
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: CustomColors.black.withOpacity(.4),
                  child: const LoadingWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Row buildListInputBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NumberInputBox(
          boxIndex: 0,
          controller: _numberInputOneController,
        ),
        const SizedBox(width: 10),
        NumberInputBox(
          boxIndex: 1,
          controller: _numberInputTwoController,
        ),
        const SizedBox(width: 10),
        NumberInputBox(
          boxIndex: 2,
          controller: _numberInputThreeController,
        ),
        const SizedBox(width: 10),
        NumberInputBox(
          boxIndex: 3,
          controller: _numberInputFourController,
        ),
        const SizedBox(width: 10),
        NumberInputBox(
          boxIndex: 4,
          controller: _numberInputFiveController,
        ),
        const SizedBox(width: 10),
        NumberInputBox(
          boxIndex: 5,
          controller: _numberInputSixController,
        ),
      ],
    );
  }
}

class NumberInputBox extends StatelessWidget {
  const NumberInputBox({
    Key? key,
    required this.controller,
    required this.boxIndex,
  }) : super(key: key);

  final int boxIndex;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          fillColor: Colors.white70,
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pink),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          isDense: true,
        ),
        controller: controller,
        style: CustomTextStyle.title1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && boxIndex != 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}
