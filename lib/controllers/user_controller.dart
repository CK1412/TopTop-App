import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/utils/custom_exception.dart';

import '../models/user.dart' as user_model;
import '../models/notification.dart' as notification_model;

class UserControllerNotifier
    extends StateNotifier<AsyncValue<user_model.User?>> {
  final Reader _reader;
  final String? _userId;

  UserControllerNotifier(this._reader, this._userId)
      : super(const AsyncValue.loading()) {
    if (_userId != null) {
      retrieveUser();
    }
  }

  Future<void> retrieveUser({bool isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    try {
      final user = await _reader(userServiceProvider).getUser(_userId!);
      //? amouted like the user != null
      if (mounted) {
        state = AsyncValue.data(user);
      }
    } on CustomException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  //* Add new user
  Future<void> addUser(user_model.User user) async {
    final _isNewUser = await _reader(userServiceProvider).isNewUser(user.id);

    if (!_isNewUser) {
      debugPrint(
          'hahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahahhahahahhahahhahahahahahahahahahahah');
      _reader(notificationServiceProvider).addNotification(
        notification_model.Notification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          messageContent: 'Welcome back! We are missing you very much.',
          sendingTime: DateTime.now(),
          userId: user.id,
        ),
      );
      return;
    }

    try {
      await _reader(userServiceProvider).addUser(user);
      state = AsyncValue.data(user);
      // notification
      _reader(notificationServiceProvider).addNotification(
        notification_model.Notification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          messageContent:
              'Welcome to TopTop. Wish you have moments of relaxation and fun😊.',
          sendingTime: DateTime.now(),
          userId: user.id,
        ),
      );
    } on CustomException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  // * Update user
  Future<void> updateUser({
    required String id,
    required user_model.User userUpdated,
  }) async {
    try {
      await _reader(userServiceProvider).updateUser(
        userId: userUpdated.id,
        userUpdated: userUpdated,
      );
      state = AsyncValue.data(userUpdated);
    } on CustomException catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
