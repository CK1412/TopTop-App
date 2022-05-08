import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/src/constants.dart';
import '../models/notification.dart' as notification_model;

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  Future<void> _markReadAll(
      List<notification_model.Notification> notifications) async {
    for (var i = 0; i < notifications.length; i++) {
      if (notifications[i].viewingStatus == false) {
        ref.read(notificationControllerProvider.notifier).updateNotification(
              notificationId: notifications[i].id,
              notificationUpdated:
                  notifications[i].copyWith(viewingStatus: true),
            );
      }
    }
  }

  Future<void> _markRead(notification_model.Notification notification) async {
    if (notification.viewingStatus) return;
    ref.read(notificationControllerProvider.notifier).updateNotification(
          notificationId: notification.id,
          notificationUpdated: notification.copyWith(viewingStatus: true),
        );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationControllerProvider);

    return SafeArea(
      child: SizedBox.expand(
        child: notifications!.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: Text(
                      'Notifications',
                      style: CustomTextStyle.title1
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(height: 0),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed:
                          notifications.any((e) => e.viewingStatus == false)
                              ? () => _markReadAll(notifications)
                              : null,
                      child: const Text('Mark as read all'),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) => Container(
                        color: notifications[index].viewingStatus
                            ? null
                            : CustomColors.pink.withOpacity(.05),
                        child: ListTile(
                          leading: const CircleAvatar(),
                          title: Text(notifications[index].messageContent),
                          subtitle: Text(
                            DateFormat.yMd()
                                .add_jm()
                                .format(notifications[index].sendingTime),
                          ),
                          onTap: notifications[index].viewingStatus
                              ? null
                              : () => _markRead(notifications[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
