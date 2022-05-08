import 'dart:convert';

class Notification {
  final String id;
  final String userId;
  final String messageContent;
  final DateTime sendingTime;
  final bool viewingStatus;

  Notification({
    required this.id,
    required this.userId,
    required this.messageContent,
    required this.sendingTime,
    this.viewingStatus = false,
  });

  Notification copyWith({
    String? id,
    String? userId,
    String? messageContent,
    DateTime? sendingTime,
    bool? viewingStatus,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      messageContent: messageContent ?? this.messageContent,
      sendingTime: sendingTime ?? this.sendingTime,
      viewingStatus: viewingStatus ?? this.viewingStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      NotificationField.id: id,
      NotificationField.userId: userId,
      NotificationField.messageContent: messageContent,
      NotificationField.sendingTime: sendingTime.millisecondsSinceEpoch,
      NotificationField.viewingStatus: viewingStatus,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map[NotificationField.id] ?? '',
      userId: map[NotificationField.userId] ?? '',
      messageContent: map[NotificationField.messageContent] ?? '',
      sendingTime: DateTime.fromMillisecondsSinceEpoch(
        map[NotificationField.sendingTime],
      ),
      viewingStatus: map['viewingStatus'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) => Notification.fromMap(
        json.decode(source),
      );
}

class NotificationField {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String messageContent = 'messageContent';
  static const String sendingTime = 'sendingTime';
  static const String viewingStatus = 'viewingStatus';
}
