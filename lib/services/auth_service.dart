import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/providers.dart';
import '../providers/state_notifier_providers.dart';
import '../screens/auth/verification_otp_code_screen.dart';
import '../src/constants.dart';
import '../utils/custom_exception.dart';
import '../models/user.dart' as user_model;

class AuthService {
  final Reader _reader;

  AuthService(this._reader);

  final _googleSignIn = GoogleSignIn();

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChanges =>
      _reader(firebaseAuthProvider).authStateChanges();

  User? getCurrentUser() {
    try {
      return _reader(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

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
      await _reader(firebaseAuthProvider).signInWithCredential(credential);

      if (getCurrentUser() != null) {
        _reader(currentUserControllerProvider.notifier).addUser(
          context,
          user_model.User(
            id: getCurrentUser()!.uid,
            username: getCurrentUser()!.displayName ?? 'New User',
            email: getCurrentUser()!.email ?? '',
            phoneNumber: getCurrentUser()!.phoneNumber ?? '',
            avatarUrl: getCurrentUser()!.photoURL ?? '',
            followers: [],
            following: [],
            createdDate: DateTime.now(),
            recentUpdatedDate: DateTime.now(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      FlushbarHelper.createError(message: e.message!).show(context);
    }
  }

  //! SIGN IN WITH PHONE
  Future<void> signInWithPhone(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    // ANDROID ONLY!
    await _reader(firebaseAuthProvider).verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          FlushbarHelper.createError(
            message: AppLocalizations.of(context)!
                .the_provided_phone_number_is_not_valid,
          ).show(context);
        } else {
          FlushbarHelper.createError(message: e.message!).show(context);
        }
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
        FlushbarHelper.createInformation(
          message: AppLocalizations.of(context)!
              .we_have_sent_a_code_sent_to_your_phone_Wait_for_the_message,
        ).show(context);
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
      final resutl =
          await _reader(firebaseAuthProvider).signInWithCredential(credential);

      if (getCurrentUser() != null) {
        _reader(currentUserControllerProvider.notifier).addUser(
          context,
          user_model.User(
            id: getCurrentUser()!.uid,
            username: getCurrentUser()!.displayName ?? 'New User',
            email: getCurrentUser()!.email ?? '',
            phoneNumber: getCurrentUser()!.phoneNumber ?? '',
            avatarUrl: getCurrentUser()!.photoURL ?? randomFlowerUrl,
            followers: [],
            following: [],
            createdDate: DateTime.now(),
            recentUpdatedDate: DateTime.now(),
          ),
        );
      }

      if (resutl.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      FlushbarHelper.createError(message: e.message!).show(context);
      return false;
    }
  }

  //! SIGN OUT THE CURRENT USER
  Future<void> signOut(BuildContext context) async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        _reader(firebaseAuthProvider).signOut();
      } else {
        _reader(firebaseAuthProvider).signOut();
      }
    } on FirebaseException catch (e) {
      FlushbarHelper.createError(message: e.message!).show(context);
    }
  }
}
