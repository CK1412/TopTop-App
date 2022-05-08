import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../../widgets/common/custom_elevate_button.dart';
import '../tab_screen.dart';
import '../../src/constants.dart';
import '../../src/page_routes.dart';
import '../../widgets/auth/gradient_background.dart';
import 'sign_in_with_phone_screen.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final _authController = ref.watch(authControllerProvider.notifier);

    void _signInWithPhone() {
      Navigator.of(context).push(
        CustomPageRoute(child: const SignInWithPhoneScreen()),
      );
    }

    Future<void> _signInWithGoogle() async {
      await _authController.signInWithGoogle(context);
    }

    void _signInWithFacebook() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const TabScreen(),
      ));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(
              child: GradientBackground(),
            ),
            Positioned(
              left: 30,
              right: 30,
              top: screenSize.width * .6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hello!\nWe are TopTop.',
                      style: CustomTextStyle.titleLarge
                          .copyWith(color: CustomColors.white, fontSize: 34),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                      child: Text(
                        'Create an account or login to begin adventure.',
                        style: CustomTextStyle.bodyText2
                            .copyWith(color: CustomColors.white),
                      ),
                    ),
                    CustomElevateButton(
                      iconPath: IconPath.phoneColor,
                      text: 'Continue with Phone',
                      onPressed: _signInWithPhone,
                    ),
                    CustomElevateButton(
                      iconPath: IconPath.googleColor,
                      text: 'Continue with Google',
                      onPressed: _signInWithGoogle,
                    ),
                    CustomElevateButton(
                      iconPath: IconPath.facebookRoundColor,
                      text: 'Continue with Facebook',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
