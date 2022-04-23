import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/screens/tab_screen.dart';

import '../../../providers/state.dart';
import '../../src/constants.dart';
import '../../src/custom_page_route.dart';
import '../../widgets/auth/custom_elevate_button.dart';
import '../../widgets/auth/gradient_background.dart';
import 'sign_in_with_phone_screen.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    // use this variable to access all the functions of the authentication
    final _auth = ref.watch(authProvider);

    void _signInWithGoogle() => _auth.signInWithGoogle(context);

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
                      onPressed: () {
                        Navigator.of(context).push(
                          CustomPageRoute(child: const SignInWithPhoneScreen()),
                        );
                      },
                    ),
                    CustomElevateButton(
                      iconPath: IconPath.googleColor,
                      text: 'Continue with Google',
                      onPressed: _signInWithGoogle,
                    ),
                    CustomElevateButton(
                      iconPath: IconPath.facebookRoundColor,
                      text: 'Continue with Facebook',
                      onPressed: _signInWithFacebook,
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
