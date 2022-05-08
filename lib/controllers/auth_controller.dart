import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../providers/providers.dart';
import '../models/user.dart' as user_model;

class AuthControllerNotifier extends StateNotifier<User?> {
  final Reader _reader;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthControllerNotifier(this._reader) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription =
        _reader(authServiceProvider).authStateChanges.listen(
      (user) {
        if (state == null && user != null) {
          state = user;
          _reader(userControllerProvider.notifier).addUser(
            user_model.User(
              id: state!.uid,
              username: state?.displayName ?? 'New User',
              email: state?.email ?? '',
              phoneNumber: state?.phoneNumber ?? '',
              avatarUrl: state?.photoURL ?? '',
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await _reader(authServiceProvider).signInWithGoogle(context);
  }

  Future<void> signInWithPhone(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    await _reader(authServiceProvider).signInWithPhone(
      context,
      phoneNumber: phoneNumber,
    );
  }

  Future<bool> verifyOTP(
    BuildContext context, {
    required String smsCode,
    required String verificationId,
  }) async {
    return await _reader(authServiceProvider).verifyOTP(
      context: context,
      smsCode: smsCode,
      verificationId: verificationId,
    );
  }

  Future<void> signOut(BuildContext context) async {
    await _reader(authServiceProvider).signOut(context);
  }
}
