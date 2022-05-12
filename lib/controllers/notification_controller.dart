import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/notification.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/utils/custom_exception.dart';
import '../models/notification.dart' as notification_model;

class NotificationControllerNotifier extends StateNotifier<List<Notification>> {
  final Reader _reader;

  String? userId;

  NotificationControllerNotifier(this._reader) : super([]) {
    userId = _reader(authControllerProvider)!.uid;
    if (userId != null) {
      retrieveNotificationsByUser(userId: userId.toString());
    }
  }

  Future<void> retrieveNotificationsByUser({required String userId}) async {
    try {
      final notifications = await _reader(notificationServiceProvider)
          .getNotificationsByUserId(userId);
      if (mounted) {
        state = notifications!;
      }
    } on FirebaseException catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  Future<void> addNotification(
      notification_model.Notification notification) async {
    try {
      await _reader(notificationServiceProvider).addNotification(notification);
      state = state..add(notification);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> updateNotification({
    required String notificationId,
    required notification_model.Notification notificationUpdated,
  }) async {
    try {
      await _reader(notificationServiceProvider).updateNotification(
        notificationId: notificationId,
        notificationUpdated: notificationUpdated,
      );
      state = [
        for (final notification in state)
          if (notification.id == notificationId)
            notificationUpdated
          else
            notification
      ];
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
