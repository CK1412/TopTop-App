import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/notification.dart' as notification_model;

class NotificationService {
  final CollectionReference<Map<String, dynamic>> _collection;
  NotificationService(this._collection);

  //* Add new notification
  Future<void> addNotification(
      notification_model.Notification notification) async {
    await _collection
        .doc(notification.id)
        .set(
          notification.toMap(),
        )
        .catchError((e) {
      debugPrint('"Failed to add notification: $e"');
    });
    debugPrint('Add notification sucessfully!');
  }

  //* Get notification list by userId
  Future<List<notification_model.Notification>?> getNotificationsByUserId(
      String userId) async {
    final query = await _collection.get();
    final notifications = query.docs
        .map(
          (doc) => notification_model.Notification.fromMap(doc.data()),
        )
        .toList();
    return notifications
        .where((notification) => notification.userId == userId)
        .toList();
  }

  //* Update notification
  Future<void> updateNotification({
    required String notificationId,
    required notification_model.Notification notificationUpdated,
  }) {
    return _collection
        .doc(notificationId)
        .update(notificationUpdated.toMap())
        .then(
          (value) => debugPrint("Notification Updated"),
        )
        .catchError(
          (error) => debugPrint("Failed to update notification: $error"),
        );
  }
}
