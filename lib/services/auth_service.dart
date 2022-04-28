import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as user_model;
import '../screens/auth/verification_otp_code_screen.dart';
import '../widgets/common/show_snackbar.dart';
import 'instance.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final _googleSignIn = GoogleSignIn();

  user_model.User? get currentUser => user_model.User(
        id: fireAuth.currentUser!.uid,
        username: fireAuth.currentUser?.displayName ?? '',
        email: fireAuth.currentUser?.email ?? '',
        phoneNumber: fireAuth.currentUser?.phoneNumber ?? '',
        avatarUrl: fireAuth.currentUser?.photoURL ?? '',
      );

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChange => fireAuth.authStateChanges();

  //! SIGN IN WITH GOOGLE
  Future<void> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      // Once signed in, return the UserCredential
      await fireAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  //! SIGN IN WITH PHONE
  Future<void> signInWithPhone(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    // ANDROID ONLY!
    String phoneNumberVN = '+84' + phoneNumber;

    await fireAuth.verifyPhoneNumber(
      phoneNumber: phoneNumberVN,
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showSnackbar(context, 'The provided phone number is not valid.');
        }
        showSnackbar(context, e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Update the UI - wait for the user to enter the SMS code
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerificationOtpCodeScreen(
              phoneNumber: phoneNumber,
              verifycationId: verificationId,
            ),
          ),
        );
        showSnackbar(
          context,
          'We\'ve sent a code sent to your phone. Wait for the message',
        );
      },
      timeout: const Duration(seconds: 90),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  //! VERIFY OTP SENT TO PHONE
  Future<bool> verifyOTP({
    required BuildContext context,
    required String smsCode,
    required String verificationId,
  }) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      // Sign the user in (or link) with the credential
      await fireAuth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
      return false;
    }
  }

  //! SIGN OUT THE CURRENT USER
  Future<void> signOut(BuildContext context) async {
    try {
      _googleSignIn.disconnect();
      await fireAuth.signOut();
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
  }
}
