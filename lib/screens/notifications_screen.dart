import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationControllerProvider);

    return SafeArea(
      child: SizedBox.expand(
        child: notifications!.isEmpty
            ? const SizedBox.shrink()
            : ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(notifications[index].messageContent),
                ),
              ),
      ),
    );
  }
}
